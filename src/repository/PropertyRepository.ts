import pool from '@dev_nestify/db/connection';
import { IPropertyRow } from '@dev_nestify/model/IProperty';
import { IRepository } from './IRepository';

export class PropertyRepository implements IRepository<IPropertyRow> {
  private table = 'property';

  async create(p: Partial<IPropertyRow>): Promise<IPropertyRow> {
    const cols = Object.keys(p).join(', ');
    const vals = Object.values(p);
    const placeholders = vals.map(() => '?').join(', ');
    const [res] = await pool.query<any>(`
      INSERT INTO ${this.table} (${cols})
      VALUES (${placeholders})
    `, vals);
    const insertId = (res as any).insertId as number;
    return this.retrieveById(insertId);
  }

  async retrieveAll(): Promise<IPropertyRow[]> {
    
    const [rows] = await pool.query<IPropertyRow[]>(`SELECT * FROM ${this.table}`);

    return rows;
  }

  async retrieveById(id: number): Promise<IPropertyRow> {
    const [rows] = await pool.query<IPropertyRow[]>(`SELECT * FROM ${this.table} WHERE id=?`, [id]);
    if (!rows.length) throw new Error('Not Found');
    return rows[0];
  }

  async retrieveByRange(offset: number, limit: number): Promise<IPropertyRow[]> {
    const [rows] = await pool.query<IPropertyRow[]>(
      `SELECT * FROM ${this.table} LIMIT ?,?`, [offset, limit]
    );
    return rows;
  }

  async retrieveByPayloads(criteria: Partial<IPropertyRow>): Promise<IPropertyRow[]> {
    const keys = Object.keys(criteria);
    const vals = Object.values(criteria);
    const where = keys.map(k => `${k} = ?`).join(' AND ');
    const [rows] = await pool.query<IPropertyRow[]>(`
      SELECT * FROM ${this.table} WHERE ${where}
    `, vals);
    return rows;
  }

  async updateById(id: number, p: Partial<IPropertyRow>): Promise<IPropertyRow> {
    const keys = Object.keys(p);
    const vals = Object.values(p);
    const setstmt = keys.map(k => `${k} = ?`).join(', ');
    await pool.query(`
      UPDATE ${this.table} SET ${setstmt} WHERE id=?
    `, [...vals, id]);
    return this.retrieveById(id);
  }

  async updateByPayloads(pairs: Array<{ id: number; data: Partial<IPropertyRow> }>): Promise<IPropertyRow[]> {
    const updated: IPropertyRow[] = [];
    for (const { id, data } of pairs) {
      updated.push(await this.updateById(id, data));
    }
    return updated;
  }

  async deleteById(id: number): Promise<Partial<IPropertyRow>> {
    const item = await this.retrieveById(id);
    await pool.query(`DELETE FROM ${this.table} WHERE id=?`, [id]);
    return item;
  }

  async deleteByPayloads(criteria: Partial<IPropertyRow>): Promise<Partial<IPropertyRow>[]> {
    const rows = await this.retrieveByPayloads(criteria);
    await pool.query(`DELETE FROM ${this.table} WHERE ${Object.keys(criteria).map(k=>'`'+k+'`=?').join(' AND ')}`, Object.values(criteria));
    return rows;
  }


  async deleteByIds(ids: number[]): Promise<Partial<IPropertyRow>[]> {

    const placeholders = ids.map(() => '?').join(', ');

    const [rows] = await pool.query<(IPropertyRow)[]>(
      `SELECT * FROM ${this.table} WHERE id IN (${placeholders})`,
      ids
    );

    await pool.query(
      `DELETE FROM ${this.table} WHERE id IN (${placeholders})`,
      ids
    );

    return rows.map( (row: IPropertyRow ) => ({ ...row }) ); 
  }

}
