export interface IRepository<T> {
  create(partial: Partial<T>): Promise<T>;
  retrieveAll(): Promise<T[]>;
  retrieveById(id: number): Promise<T>;
  retrieveByRange(offset: number, limit: number): Promise<T[]>;
  retrieveByPayloads(criteria: Partial<T>): Promise<T[]>;
  updateById(id: number, partial: Partial<T>): Promise<T>;
  updateByPayloads(pairs: Array<{ id: number; data: Partial<T> }>): Promise<T[]>;
  deleteById(id: number): Promise<Partial<T>>;
  deleteByPayloads(criteria: Partial<T>): Promise<Partial<T>[]>;
  deleteByIds(ids: number[]): Promise<Partial<T>[]>;
}
