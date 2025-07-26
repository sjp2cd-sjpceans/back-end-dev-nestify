import { Request, Response } from 'express';
import { PropertyService } from '@dev_nestify/service/PropertyService';

const svc = new PropertyService();

export class PropertyController {
  static async create(req: Request, res: Response) {
    const item = await svc.create(req.body);
    res.status(201).json(item);
  }

  static async getAll(_req: Request, res: Response) {
    const items = await svc.retrieveAll();
    res.json(items);
  }

  static async getById(req: Request, res: Response) {
    const id = Number(req.params.id);
    const item = await svc.retrieveById(id);
    res.json(item);
  }

  static async getRange(req: Request, res: Response) {
    const offset = Number(req.query.offset) || 0;
    const limit = Number(req.query.limit) || 10;
    const items = await svc.retrieveByRange(offset, limit);
    res.json(items);
  }

  static async query(req: Request, res: Response) {
    const criteria = req.body;
    const items = await svc.retrieveByPayloads(criteria);
    res.json(items);
  }

  static async update(req: Request, res: Response) {
    const id = Number(req.params.id);
    const item = await svc.updateById(id, req.body);
    res.json(item);
  }

  static async bulkUpdate(req: Request, res: Response) {
    const pairs = req.body as Array<{ id: number; data: Partial<any> }>;
    const items = await svc.updateByPayloads(pairs);
    res.json(items);
  }

  static async deleteById(req: Request, res: Response) {
    const id = Number(req.params.id);
    const item = await svc.deleteById(id);
    res.json(item);
  }

  static async deleteByIds(req: Request, res: Response) {
    const ids = req.body.ids as number[];
    const items = await svc.deleteByIds(ids);
    res.json(items);
  }

  static async deleteByPayload(req: Request, res: Response) {
    const criteria = req.body;
    const items = await svc.deleteByPayloads(criteria);
    res.json(items);
  }
}
