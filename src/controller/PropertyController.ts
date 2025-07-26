import { Request, Response, NextFunction } from 'express';
import { PropertyService } from '@dev_nestify/service/PropertyService';
import { IPropertyRow } from '@dev_nestify/model/IProperty';

const svc = new PropertyService();

class NotFoundError extends Error { 
  /*REM: Custom error for not found resources*/
}

export class PropertyController {

  static async create(req: Request<
      {}, IPropertyRow, Partial<IPropertyRow>
    >, 
    res: Response, next: NextFunction) 
  {
    try {
      const payload = req.body;
      if (!payload || Object.keys(payload).length === 0) {
        return res.status(400).json({ error: 'Request body cannot be empty' });
      }
      const created = await svc.create(payload);
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
      return res.status(400).json({ error: 'Invalid `id` parameter' });
    }
    try {
      const item = await svc.retrieveById(id);
      res.json(item);
    } catch (err: any) {
      if (err instanceof NotFoundError || err.message === 'Not Found') {
        res.status(404).json({ error: `Property with id=${id} not found` });
      } else {
        next(err);
      }
    }
  }

  static async getRange(
    req: Request<{}, IPropertyRow[], {}, { offset?: string; limit?: string }>,
    res: Response,
    next: NextFunction
  ) {
    const offset = parseInt(req.query.offset ?? '0', 10);
    const limit  = parseInt(req.query.limit  ?? '10',  10);

    if (Number.isNaN(offset) || offset < 0) {
      return res.status(400).json({ error: '`offset` must be a non‑negative number' });
    }
    if (Number.isNaN(limit) || limit <= 0) {
      return res.status(400).json({ error: '`limit` must be a positive number' });
    }

    try {
      const items = await svc.retrieveByRange(offset, limit);
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async query(req: Request<{}, IPropertyRow[], Partial<IPropertyRow>>, res: Response, next: NextFunction) {
    const criteria = req.body;
    if (!criteria || Object.keys(criteria).length === 0) {
      return res.status(400).json({ error: 'Query criteria cannot be empty' });
    }
    try {
      const items = await svc.retrieveByPayloads(criteria);
      res.json(items);
    } catch (err) {
      next(err);
    }
  }

  static async update(
    req: Request<{ id: string }, IPropertyRow, Partial<IPropertyRow>>,
    res: Response,
    next: NextFunction
  ) {
    const id = Number(req.params.id);
    if (Number.isNaN(id) || id <= 0) {
      return res.status(400).json({ error: 'Invalid `id` parameter' });
    }
    const payload = req.body;
    if (!payload || Object.keys(payload).length === 0) {
      return res.status(400).json({ error: 'Update payload cannot be empty' });
    }
    try {
      const updated = await svc.updateById(id, payload);
      res.json(updated);
    } catch (err: any) {
      if (err instanceof NotFoundError || err.message === 'Not Found') {
        res.status(404).json({ error: `Property with id=${id} not found` });
      } else {
        next(err);
      }
    }
  }

  static async bulkUpdate(
    req: Request<{}, IPropertyRow[], Array<{ id: number; data: Partial<IPropertyRow> }>>,
    res: Response,
    next: NextFunction
  ) {
    const pairs = req.body;
    if (!Array.isArray(pairs) || pairs.length === 0) {
      return res.status(400).json({ error: 'Request body must be a non‑empty array' });
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
      return res.status(400).json({ error: 'Invalid `id` parameter' });
    }
    try {
      await svc.retrieveById(id);            // check existence
      await svc.deleteById(id);
      res.status(204).send();                // no content
    } catch (err: any) {
      if (err instanceof NotFoundError || err.message === 'Not Found') {
        res.status(404).json({ error: `Property with id=${id} not found` });
      } else {
        next(err);
      }
    }
  }

  static async deleteByIds(
    req: Request<{}, unknown, { ids: number[] }>,
    res: Response,
    next: NextFunction
  ) {
    const { ids } = req.body;
    if (!Array.isArray(ids) || ids.some(id => typeof id !== 'number' || id <= 0)) {
      return res.status(400).json({ error: '`ids` must be an array of positive numbers' });
    }
    try {
      const deleted = await svc.deleteByIds(ids);
      res.json(deleted);
    } catch (err) {
      next(err);
    }
  }

  static async deleteByPayload(
    req: Request<{}, unknown, Partial<IPropertyRow>>,
    res: Response,
    next: NextFunction
  ) {
    const criteria = req.body;
    if (!criteria || Object.keys(criteria).length === 0) {
      return res.status(400).json({ error: 'Delete criteria cannot be empty' });
    }
    try {
      const deleted = await svc.deleteByPayloads(criteria);
      res.json(deleted);
    } catch (err) {
      next(err);
    }
  }
}
