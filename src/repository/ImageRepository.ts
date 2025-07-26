import pool from '@dev_nestify/db/connection';
import { IImageRow } from '@dev_nestify/model/IImage';
import { IRepository } from './IRepository';

export class ImageRepository implements IRepository<IImageRow> {
  private table = 'image';

  async create(p: Partial<IImageRow>): Promise<IImageRow> {
    const cols = Object.keys(p).join(', ');
    const vals = Object.values(p);
    const placeholders = vals.map(() => '?').join(', ');
    const [res] = await pool.query<any>(
      `INSERT INTO \`${this.table}\` (${cols}) VALUES (${placeholders})`,
      vals
    );
    const insertId: number = (res as any).insertId;
    return this.retrieveById(insertId);
  }

  async retrieveAll(): Promise<IImageRow[]> {
    const [rows] = await pool.query<IImageRow[]>(`SELECT * FROM \`${this.table}\``);
    return rows;
  }

  async retrieveById(id: number): Promise<IImageRow> {
    const [rows] = await pool.query<IImageRow[]>(
      `SELECT * FROM \`${this.table}\` WHERE id = ?`,
      [id]
    );
    if (!rows.length) throw new Error('Not Found');
    return rows[0];
  }

  async retrieveByRange(offset: number, limit: number): Promise<IImageRow[]> {
    const [rows] = await pool.query<IImageRow[]>(
      `SELECT * FROM \`${this.table}\` LIMIT ?, ?`,
      [offset, limit]
    );
    return rows;
  }

  async retrieveByPayloads(criteria: Partial<IImageRow>): Promise<IImageRow[]> {
    const keys = Object.keys(criteria) as Array<keyof IImageRow>;
    if (keys.length === 0) return [];
    const where = keys.map(k => `\`${k}\` = ?`).join(' AND ');
    const vals = keys.map(k => (criteria[k] as any));
    const [rows] = await pool.query<IImageRow[]>(
      `SELECT * FROM \`${this.table}\` WHERE ${where}`,
      vals
    );
    return rows;
  }

  async updateById(id: number, p: Partial<IImageRow>): Promise<IImageRow> {
    const keys = Object.keys(p) as Array<keyof IImageRow>;
    if (keys.length === 0) return this.retrieveById(id);
    const setStmt = keys.map(k => `\`${k}\` = ?`).join(', ');
    const vals = keys.map(k => (p[k] as any));
    await pool.query(
      `UPDATE \`${this.table}\` SET ${setStmt} WHERE id = ?`,
      [...vals, id]
    );
    return this.retrieveById(id);
  }

  async updateByPayloads(pairs: Array<{ id: number; data: Partial<IImageRow> }>): Promise<IImageRow[]> {
    const updated: IImageRow[] = [];
    for (const { id, data } of pairs) {
      updated.push(await this.updateById(id, data));
    }
    return updated;
  }

  async deleteById(id: number): Promise<Partial<IImageRow>> {
    const item = await this.retrieveById(id);
    await pool.query(`DELETE FROM \`${this.table}\` WHERE id = ?`, [id]);
    return item;
  }

  async deleteByPayloads(criteria: Partial<IImageRow>): Promise<Partial<IImageRow>[]> {
    const rows = await this.retrieveByPayloads(criteria);
    const keys = Object.keys(criteria) as Array<keyof IImageRow>;
    if (keys.length) {
      const where = keys.map(k => `\`${k}\` = ?`).join(' AND ');
      const vals = keys.map(k => (criteria[k] as any));
      await pool.query(`DELETE FROM \`${this.table}\` WHERE ${where}`, vals);
    }
    return rows;
  }

  async deleteByIds(ids: number[]): Promise<Partial<IImageRow>[]> {
    if (ids.length === 0) return [];
    const placeholders = ids.map(() => '?').join(', ');
    const [rows] = await pool.query<IImageRow[]>(
      `SELECT * FROM \`${this.table}\` WHERE id IN (${placeholders})`,
      ids
    );
    await pool.query(`DELETE FROM \`${this.table}\` WHERE id IN (${placeholders})`, ids);
    return rows;
  }
}
