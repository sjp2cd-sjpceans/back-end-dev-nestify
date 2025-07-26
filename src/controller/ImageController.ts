import { Request, Response, NextFunction } from 'express';
import { ImageService } from '@dev_nestify/service/ImageService';
import { IImageRow } from '@dev_nestify/model/IImage';

const svc = new ImageService();

export class ImageController {
  static async create(req: Request<{}, IImageRow, Partial<IImageRow>>, res: Response, next: NextFunction) {
    try {
      if (Object.keys(req.body).length === 0) {
        return res.status(400).json({ error: 'Request body cannot be empty' });
      }
      const created = await svc.create(req.body);
      res.status(201).json(created);
    } catch (err) {
      next(err);
    }
  }

  static async getAll(_req: Request, res: Response, next: NextFunction) {
    try {
      const items = await svc.retrieveAll();
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async getById(req: Request<{ id: string }>, res: Response, next: NextFunction) {
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
