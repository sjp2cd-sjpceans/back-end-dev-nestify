import { RowDataPacket } from 'mysql2/promise';

export interface IProperty {
  id: number;
  name: string;
  description: string;
  addressId: number;
  propertyTypeId: number;
  size: number;
  price: number;
  statusId: number;
  hadDiscount: boolean;
  discountPrice?: number | null;
  actorOwnerId?: number | null;
  actorOfficeId?: number | null;
  actorAgentId?: number | null;
}

export interface IPropertyRow extends IProperty, RowDataPacket {}
