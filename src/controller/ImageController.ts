import { Request, Response, NextFunction } from 'express';
import { ImageService } from '@dev_nestify/service/ImageService';
import { IImageRow } from '@dev_nestify/model/IImage';
import * as path from 'path'
import * as fs from 'fs';

import multer from 'multer';

const relativePublicDir = ( process.env.NODE_ENV === 'production' ) ? 'public/main' : 'public/test';

const relativeUploadDir = `/${relativePublicDir}/asset/upload`;

const relativeUploadImageDir = `${relativeUploadDir}/img`;

const uploadImageAndNamingStorage = multer.diskStorage({

  destination: (_req, _file, nextFunc) => {

    const uploadDir = path.join(__dirname, `../../${relativeUploadImageDir}`);
    // const uploadDir = relativeUploadImageDir;

    if (!fs.existsSync(uploadDir)) {

      fs.mkdirSync(uploadDir, { recursive: true });
    }

    nextFunc(null, uploadDir);
  },

  filename: (_req, file, nextFunc) => {

    const now: Date         = new Date();
    const y: number         = now.getFullYear();               
    const d: number         = now.getDate(); //REM: 1–31
    const MM: string        = String(now.getMonth() + 1).padStart(2, '0');
    const H: number         = now.getHours(); //REM: 0–23
    const mm: string        = String(now.getMinutes()).padStart(2, '0');
    const s: string         = String(now.getSeconds()).padStart(2, '0');
    const ms: string        = String(now.getMilliseconds()).padStart(3, '0');
    const nsBigInt: bigint  = process.hrtime.bigint();

    // const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const uniqueSuffix = `${y}-${d}-${MM}-${H}-${mm}-${s}-${ms}-${nsBigInt}`;
    const ext = path.extname(file.originalname);
    nextFunc(null, path.parse(file.originalname).name + '_' + uniqueSuffix + ext);
  }
});

const imageFilter = (_req: Request, file: Express.Multer.File, nextFunc: multer.FileFilterCallback) => {

  const allowedTypes = [
    'image/jpeg',        //REM: .jpeg, .jpg
    'image/png',
    'image/gif',
    'image/webp',
    'image/bmp',
    'image/svg+xml'     //RME: .svg
    // 'image/tiff',        //REM: .tif, .tiff
    // 'image/x-icon',      //REM: .ico
    // 'image/vnd.microsoft.icon', //REM: .ico alternative
    // 'image/avif',        //REM: .avif
    // 'image/heic',        //REM: .heic (Apple)
    // 'image/heif'         //RME: .heif (Apple)
  ];

  if (allowedTypes.includes(file.mimetype)) {

    nextFunc(null, true);
  } else {

    nextFunc(new Error(`Only image files are allowed! [${allowedTypes.join(', ')}]`));
  }
};

const uploadImageMiddleware = multer({ 
  storage: uploadImageAndNamingStorage,
  fileFilter: imageFilter,
  limits: { fileSize: 5 * 1024 * 1024 } //REM: 5MB limit
});

const svc = new ImageService();

export class ImageController {

  static uploadMiddleware = uploadImageMiddleware.single('image');

  static async create(req: Request, res: Response, next: NextFunction) {

    try {

      if (!req.file) {

        return res.status(400).json({ error: 'No image file uploaded' });
      }

      const fileUrl = `${relativeUploadImageDir}/${req.file.filename}`;
      
      const imageData: Partial<IImageRow> = {

        url: fileUrl,
        alt_text: req.body.altText || null,
        is_active: req.body.isActive !== 'false',
        format: req.file.mimetype.split('/')[1] || null
      } as Partial<IImageRow>;

      const created = await svc.create(imageData);
      res.status(201).json(created);
    } catch (err) {

      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      next(err);
    }
  }

  // static async create(req: Request<{}, IImageRow, Partial<IImageRow>>, res: Response, next: NextFunction) {
  //   try {
  //     if (Object.keys(req.body).length === 0) {
  //       return res.status(400).json({ error: 'Request body cannot be empty' });
  //     }
  //     const created = await svc.create(req.body);
  //     res.status(201).json(created);
  //   } catch (err) {
  //     next(err);
  //   }
  // }

  static async getAll(_req: Request, res: Response, next: NextFunction) {
    try {
      const items = await svc.retrieveAll();
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async getById(
    req: Request<{ id: string }>, 
    res: Response, 
    next: NextFunction
  ) {

    const id = Number(req.params.id);

    if (Number.isNaN(id) || id <= 0) {

      return res.status(400).json({ error: 'Invalid `id`' });
    }

    try {

      const item = await svc.retrieveById(id);
      res.json(item);
    } catch (err: any) {

      if (err.message === 'Not Found') {

        res.status(404).json({ error: `Image ${id} not found` });
      } else {

        next(err);
      }
    }
  }

  static async getByIdAndShow(
    req: Request<{ id: string }>, 
    res: Response, 
    next: NextFunction
  ) {

    const id = Number(req.params.id);

    if (Number.isNaN(id) || id <= 0) {

      return res.status(400).json({ error: 'Invalid `id`' });
    }

    try {

      const image = await svc.retrieveById(id);

      if (!image || typeof image.url !== 'string' || image.url.trim() === '') {
        return res.status(404).json({ error: `Image ${id} not found` });
      }

      if (!/\.(jpg|jpeg|png|gif|bmp|webp|svg)$/i.test(image.url)) {
        return res.status(400).json({ error: 'Invalid image format' });
      }

      const filePath = path.join(__dirname, '../../', image.url);

      if (!fs.existsSync(filePath)) {
        
        return res.status(404).json({ error: `Image file not found on server: ${filePath}` });
      }

      res.sendFile(filePath, (err) => {
        
        if (err) next(err);
      });

    } catch (err: any) {
      
      next(err);
    }
  }

  static async getRange(req: Request<{}, IImageRow[], {}, { offset?: string; limit?: string }>, res: Response, next: NextFunction) {
    const offset = parseInt(req.query.offset ?? '0', 10);
    const limit  = parseInt(req.query.limit  ?? '10',  10);
    if (Number.isNaN(offset) || Number.isNaN(limit) || offset < 0 || limit <= 0) {
      return res.status(400).json({ error: 'Invalid pagination parameters' });
    }
    try {
      const items = await svc.retrieveByRange(offset, limit);
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async query(req: Request<{}, IImageRow[], Partial<IImageRow>>, res: Response, next: NextFunction) {
    if (Object.keys(req.body).length === 0) {
      return res.status(400).json({ error: 'Query body cannot be empty' });
    }
    try {
      const items = await svc.retrieveByPayloads(req.body);
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async update(req: Request<{ id: string }, IImageRow, Partial<IImageRow>>, res: Response, next: NextFunction) {
    const id = Number(req.params.id);
    if (Number.isNaN(id) || id <= 0 || Object.keys(req.body).length === 0) {
      return res.status(400).json({ error: 'Invalid request' });
    }
    try {
      const updated = await svc.updateById(id, req.body);
      res.json(updated);
    } catch (err: any) {
      if (err.message === 'Not Found') {
        res.status(404).json({ error: `Image ${id} not found` });
      } else {
        next(err);
      }
    }
  }

  static async bulkUpdate(req: Request<{}, IImageRow[], Array<{ id: number; data: Partial<IImageRow> }>>, res: Response, next: NextFunction) {
    const pairs = req.body;
    if (!Array.isArray(pairs) || pairs.length === 0) {
      return res.status(400).json({ error: 'Request body must be non‑empty array' });
    }
    try {
      const updated = await svc.updateByPayloads(pairs);
      res.json(updated);
    } catch (err) {
      next(err);
    }
  }

  static async deleteById(req: Request<{ id: string }>, res: Response, next: NextFunction) {
    const id = Number(req.params.id);
    if (Number.isNaN(id) || id <= 0) {
      return res.status(400).json({ error: 'Invalid `id`' });
    }
    try {
      await svc.deleteById(id);
      res.status(204).send();
    } catch (err: any) {
      if (err.message === 'Not Found') {
        res.status(404).json({ error: `Image ${id} not found` });
      } else {
        next(err);
      }
    }
  }

  static async deleteByPayload(req: Request<{}, Partial<IImageRow>[], Partial<IImageRow>>, res: Response, next: NextFunction) {
    if (Object.keys(req.body).length === 0) {
      return res.status(400).json({ error: 'Delete criteria cannot be empty' });
    }
    try {
      const deleted = await svc.deleteByPayloads(req.body);
      res.json(deleted);
    } catch (err) {
      next(err);
    }
  }

  static async deleteByIds(req: Request<{}, Partial<IImageRow>[], { ids: number[] }>, res: Response, next: NextFunction) {
    const { ids } = req.body;
    if (!Array.isArray(ids) || ids.some(i => typeof i !== 'number' || i <= 0)) {
      return res.status(400).json({ error: '`ids` must be array of positive numbers' });
    }
    try {
      const deleted = await svc.deleteByIds(ids);
      res.json(deleted);
    } catch (err) {
      next(err);
    }
  }
}
