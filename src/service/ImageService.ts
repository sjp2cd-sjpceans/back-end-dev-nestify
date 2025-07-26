import { IImageRow } from '@dev_nestify/model/IImage';
import { ImageRepository } from '@dev_nestify/repository/ImageRepository';

export class ImageService {
  constructor(private repo = new ImageRepository()) {}

  create(data: Partial<IImageRow>): Promise<IImageRow> {
    return this.repo.create(data);
  }

  retrieveAll(): Promise<IImageRow[]> {
    return this.repo.retrieveAll();
  }

  retrieveById(id: number): Promise<IImageRow> {
    return this.repo.retrieveById(id);
  }

  retrieveByRange(offset: number, limit: number): Promise<IImageRow[]> {
    return this.repo.retrieveByRange(offset, limit);
  }

  retrieveByPayloads(criteria: Partial<IImageRow>): Promise<IImageRow[]> {
    return this.repo.retrieveByPayloads(criteria);
  }

  updateById(id: number, data: Partial<IImageRow>): Promise<IImageRow> {
    return this.repo.updateById(id, data);
  }

  updateByPayloads(pairs: Array<{ id: number; data: Partial<IImageRow> }>): Promise<IImageRow[]> {
    return this.repo.updateByPayloads(pairs);
  }

  deleteById(id: number): Promise<Partial<IImageRow>> {
    return this.repo.deleteById(id);
  }

  deleteByPayloads(criteria: Partial<IImageRow>): Promise<Partial<IImageRow>[]> {
    return this.repo.deleteByPayloads(criteria);
  }

  deleteByIds(ids: number[]): Promise<Partial<IImageRow>[]> {
    return this.repo.deleteByIds(ids);
  }
}
