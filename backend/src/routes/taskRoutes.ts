import { Router } from 'express';
import { TaskController } from '../controller/TaskController';

const router = Router();
const taskController = new TaskController();

router.post('/tasks', (req, res) => taskController.create(req, res));
router.get('/tasks', (req, res) => taskController.findAll(req, res));
router.get('/tasks/:id', (req, res) => taskController.findOne(req, res));
router.put('/tasks/:id', (req, res) => taskController.update(req, res));
router.delete('/tasks/:id', (req, res) => taskController.delete(req, res));

export default router;

