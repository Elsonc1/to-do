import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import * as dotenv from 'dotenv';
import path from 'path';
import { AppDataSource } from './data-source';
import taskRoutes from './routes/taskRoutes';
import authRoutes from './routes/authRoutes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'API está funcionando' });
});

app.use('/', authRoutes);
app.use('/', taskRoutes);
AppDataSource.initialize()
  .then(async () => {
    console.log('Banco de dados conectado com sucesso');

    try {
      console.log('Executando migrações...');
      await AppDataSource.runMigrations();
      console.log('Migrações executadas com sucesso');
    } catch (migrationError) {
      console.warn('Aviso ao executar migrações:', migrationError);
    }

    app.listen(PORT, () => {
      console.log(`Servidor rodando na porta ${PORT}`);
      console.log(`API disponível em http://localhost:${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Erro ao conectar com o banco de dados:', error);
    process.exit(1);
  });

process.on('unhandledRejection', (error) => {
  console.error('Unhandled Rejection:', error);
  process.exit(1);
});

