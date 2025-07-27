import { Router } from 'express';
import { ImageController } from '@dev_nestify/controller/ImageController';
import { verifyJwt } from '@dev_nestify/auth/jwtMiddleware';

const router = Router();

router.get('/',       ImageController.getAll);
router.get('/range',  ImageController.getRange);
router.get('/:id',    ImageController.getById);
router.get('/:id/show',ImageController.getByIdAndShow);
router.post('/query', ImageController.query);

router.post('/',      verifyJwt, ImageController.create);
router.put('/:id',    verifyJwt, ImageController.update);
router.put('/',       verifyJwt, ImageController.bulkUpdate);
router.delete('/:id', verifyJwt, ImageController.deleteById);
router.post('/delete',verifyJwt, ImageController.deleteByPayload);
router.post('/delete-ids', verifyJwt, ImageController.deleteByIds);

export default router;
