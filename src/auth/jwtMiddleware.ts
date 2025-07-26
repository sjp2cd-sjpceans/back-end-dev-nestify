import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthRequest extends Request {

  user?: { userName: string; };
}

const JWT_SECRET = process.env.NESTIFY_JWT_SECRET!;
const JWT_EXPIRATION = process.env.NESTIFY_JWT_EXPIRATION!;

export function signToken( userName: string ): string {
  return jwt.sign(
    { userName }, 
    JWT_SECRET, 
    { expiresIn: Number(JWT_EXPIRATION) }
  );
}

export function verifyToken(token: string): { userName: string; } {

  return jwt.verify(token, JWT_SECRET) as { userName: string };
}

export function verifyJwt(req: AuthRequest, res: Response, next: NextFunction) {

  const auth = req.headers.authorization;
  if (!auth?.startsWith('Bearer ')) {

    return res.status(401).json({ error: 'No token' });
  }

  const token = auth.slice(7);
  try {

    const payload = verifyToken( token );
    req.user = payload;
    next();
  } catch {
    
    return res.status(401).json({ error: 'Invalid token' });
  }
}
