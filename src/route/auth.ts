import { Router } from 'express';
import { AuthController } from '@dev_nestify/controller/AuthController';
import { verifyJwt } from '@dev_nestify/auth/jwtMiddleware';

const router = Router();

// Public routes
router.post('/login', AuthController.login);
router.post('/register', AuthController.register);

// Protected routes
router.get('/verify', verifyJwt, AuthController.verify);
router.get('/me', verifyJwt, AuthController.me);

export default router; 