import pool from '@dev_nestify/db/connection';
import { IPropertyRow, IEnrichedPropertyRow } from '@dev_nestify/model/IProperty';
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

  // New method to retrieve enriched property data with joins
  async retrieveAllEnriched(): Promise<IEnrichedPropertyRow[]> {
    const query = `
      SELECT 
        p.id,
        p.name,
        p.description,
        p.size,
        p.price,
        p.had_discount as hadDiscount,
        p.discount_price as discountPrice,
        lpt.name as propertyType,
        ls.name as status,
        a.unit_number as unitNumber,
        a.street,
        a.city,
        a.zip_code as zipCode,
        c.name as country,
        mc.latitude,
        mc.longitude,
        ap.first_name as agentFirstName,
        ap.last_name as agentLastName,
        ap.email as agentEmail,
        ap.phone as agentPhone,
        ap.id as agentId
      FROM property p
      LEFT JOIN lookup_property_type lpt ON p.property_type_id = lpt.id
      LEFT JOIN lookup_status ls ON p.status_id = ls.id
      LEFT JOIN address a ON p.address_id = a.id
      LEFT JOIN country c ON a.country_id = c.id
      LEFT JOIN map_coordinate mc ON mc.address_id = a.id
      LEFT JOIN actor_agent aa ON p.actor_agent_id = aa.actor_profile_id
      LEFT JOIN actor_profile ap ON aa.actor_profile_id = ap.id
      ORDER BY p.id
    `;

    const [rows] = await pool.query<any[]>(query);
    
    // Group results and fetch images for each property
    const propertiesMap = new Map<number, any>();
    
    for (const row of rows) {
      if (!propertiesMap.has(row.id)) {
        propertiesMap.set(row.id, {
          id: row.id,
          name: row.name,
          description: row.description,
          size: row.size,
          price: row.price,
          hadDiscount: row.hadDiscount,
          discountPrice: row.discountPrice,
          propertyType: row.propertyType,
          status: row.status,
          address: {
            unitNumber: row.unitNumber,
            street: row.street,
            city: row.city,
            zipCode: row.zipCode,
            country: row.country,
            latitude: row.latitude,
            longitude: row.longitude,
          },
          agent: row.agentId ? {
            id: row.agentId,
            firstName: row.agentFirstName,
            lastName: row.agentLastName,
            email: row.agentEmail,
            phone: row.agentPhone,
          } : undefined,
          images: []
        });
      }
    }

    // Fetch images for all properties
    const propertyIds = Array.from(propertiesMap.keys());
    if (propertyIds.length > 0) {
      const placeholders = propertyIds.map(() => '?').join(', ');
      const imageQuery = `
        SELECT 
          ip.property_id,
          i.id,
          i.url,
          i.alt_text as altText,
          ip.is_primary as isPrimary,
          i.format
        FROM image_property ip
        JOIN image i ON ip.image_id = i.id
        WHERE ip.property_id IN (${placeholders})
        ORDER BY ip.property_id, ip.is_primary DESC, i.id
      `;
      
      const [imageRows] = await pool.query<any[]>(imageQuery, propertyIds);
      
      for (const imageRow of imageRows) {
        const property = propertiesMap.get(imageRow.property_id);
        if (property) {
          property.images.push({
            id: imageRow.id,
            url: imageRow.url,
            altText: imageRow.altText,
            isPrimary: imageRow.isPrimary,
            format: imageRow.format
          });
        }
      }
    }

    return Array.from(propertiesMap.values()) as IEnrichedPropertyRow[];
  }

  // New method to retrieve a single enriched property by ID
  async retrieveByIdEnriched(id: number): Promise<IEnrichedPropertyRow> {
    const query = `
      SELECT 
        p.id,
        p.name,
        p.description,
        p.size,
        p.price,
        p.had_discount as hadDiscount,
        p.discount_price as discountPrice,
        lpt.name as propertyType,
        ls.name as status,
        a.unit_number as unitNumber,
        a.street,
        a.city,
        a.zip_code as zipCode,
        c.name as country,
        mc.latitude,
        mc.longitude,
        ap.first_name as agentFirstName,
        ap.last_name as agentLastName,
        ap.email as agentEmail,
        ap.phone as agentPhone,
        ap.id as agentId
      FROM property p
      LEFT JOIN lookup_property_type lpt ON p.property_type_id = lpt.id
      LEFT JOIN lookup_status ls ON p.status_id = ls.id
      LEFT JOIN address a ON p.address_id = a.id
      LEFT JOIN country c ON a.country_id = c.id
      LEFT JOIN map_coordinate mc ON mc.address_id = a.id
      LEFT JOIN actor_agent aa ON p.actor_agent_id = aa.actor_profile_id
      LEFT JOIN actor_profile ap ON aa.actor_profile_id = ap.id
      WHERE p.id = ?
    `;

    const [rows] = await pool.query<any[]>(query, [id]);
    
    if (!rows.length) {
      throw new Error('Not Found');
    }

    const row = rows[0];
    const property: any = {
      id: row.id,
      name: row.name,
      description: row.description,
      size: row.size,
      price: row.price,
      hadDiscount: row.hadDiscount,
      discountPrice: row.discountPrice,
      propertyType: row.propertyType,
      status: row.status,
      address: {
        unitNumber: row.unitNumber,
        street: row.street,
        city: row.city,
        zipCode: row.zipCode,
        country: row.country,
        latitude: row.latitude,
        longitude: row.longitude,
      },
      agent: row.agentId ? {
        id: row.agentId,
        firstName: row.agentFirstName,
        lastName: row.agentLastName,
        email: row.agentEmail,
        phone: row.agentPhone,
      } : undefined,
      images: []
    };

    // Fetch images for this property
    const imageQuery = `
      SELECT 
        i.id,
        i.url,
        i.alt_text as altText,
        ip.is_primary as isPrimary,
        i.format
      FROM image_property ip
      JOIN image i ON ip.image_id = i.id
      WHERE ip.property_id = ?
      ORDER BY ip.is_primary DESC, i.id
    `;
    
    const [imageRows] = await pool.query<any[]>(imageQuery, [id]);
    
    for (const imageRow of imageRows) {
      property.images.push({
        id: imageRow.id,
        url: imageRow.url,
        altText: imageRow.altText,
        isPrimary: imageRow.isPrimary,
        format: imageRow.format
      });
    }

    return property as IEnrichedPropertyRow;
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
