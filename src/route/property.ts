import { Router } from 'express';
import { PropertyController } from '@dev_nestify/controller/PropertyController';
import { verifyJwt } from '@dev_nestify/auth/jwtMiddleware';

const router = Router();

router.get('/',       PropertyController.getAll);
router.get('/range',  PropertyController.getRange);
router.get('/:id',    PropertyController.getById);
router.post('/query', PropertyController.query);

router.post('/',      verifyJwt, PropertyController.create);
router.put('/:id',    verifyJwt, PropertyController.update);
router.put('/',       verifyJwt, PropertyController.bulkUpdate);
router.delete('/:id', verifyJwt, PropertyController.deleteById);
router.post('/delete',verifyJwt, PropertyController.deleteByPayload);
router.post('/delete-ids', verifyJwt, PropertyController.deleteByIds);

export default router;
