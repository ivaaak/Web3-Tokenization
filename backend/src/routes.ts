import express from 'express';
import userController from './controllers/userController';
import leadController from './controllers/leadController';
import checkoutController from './controllers/stripe/checkoutController';

const router = express.Router();

// Register your controllers
router.use('/users', userController);
router.use('/lead', leadController);
router.use('/checkout', checkoutController);

export default router;
