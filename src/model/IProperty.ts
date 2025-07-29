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

// Enhanced property interface with joined data
export interface IEnrichedProperty {
  id: number;
  name: string;
  description: string;
  size: number;
  price: number;
  hadDiscount: boolean;
  discountPrice?: number | null;
  propertyType: string;
  status: string;
  address: {
    unitNumber?: string;
    street: string;
    city: string;
    zipCode: string;
    country: string;
    latitude?: number;
    longitude?: number;
  };
  images: {
    id: number;
    url: string;
    altText: string;
    isPrimary: boolean;
    format: string;
  }[];
  agent?: {
    id: number;
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
  };
}

export interface IEnrichedPropertyRow extends IEnrichedProperty, RowDataPacket {}
