import { RowDataPacket } from 'mysql2/promise';

export interface IImage {
  id: number;
  url: string;
  altText?: string | null;
  isActive: boolean;
  format?: string | null;
  createdAt?: Date;
  updatedAt?: Date;
}
export interface IImageRow extends IImage, RowDataPacket {}