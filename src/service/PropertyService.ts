import { IPropertyRow } from '@dev_nestify/model/IProperty';
import { PropertyRepository } from '@dev_nestify/repository/PropertyRepository';

export class PropertyService {
  constructor(private repo = new PropertyRepository()) {}

  create(data: Partial<IPropertyRow>): Promise<IPropertyRow> {
    return this.repo.create(data);
  }

  retrieveAll(): Promise<IPropertyRow[]> {
    return this.repo.retrieveAll();
  }

  retrieveById(id: number): Promise<IPropertyRow> {
    return this.repo.retrieveById(id);
  }

  retrieveByRange(offset: number, limit: number): Promise<IPropertyRow[]> {
    return this.repo.retrieveByRange(offset, limit);
  }

  retrieveByPayloads(criteria: Partial<IPropertyRow>): Promise<IPropertyRow[]> {
    return this.repo.retrieveByPayloads(criteria);
  }

  updateById(id: number, data: Partial<IPropertyRow>): Promise<IPropertyRow> {
    return this.repo.updateById(id, data);
  }

  updateByPayloads(pairs: Array<{ id: number; data: Partial<IPropertyRow> }>): Promise<IPropertyRow[]> {
    return this.repo.updateByPayloads(pairs);
  }

  deleteById(id: number): Promise<Partial<IPropertyRow>> {
    return this.repo.deleteById(id);
  }

  deleteByPayloads(criteria: Partial<IPropertyRow>): Promise<Partial<IPropertyRow>[]> {
    return this.repo.deleteByPayloads(criteria);
  }

  deleteByIds(ids: number[]): Promise<Partial<IPropertyRow>[]> {
    return this.repo.deleteByIds(ids);
  }
}
