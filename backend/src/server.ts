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

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir arquivos estáticos (uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'API está funcionando' });
});

// Routes
app.use('/', authRoutes); // Rotas de autenticação (públicas)
app.use('/', taskRoutes); // Rotas de tarefas

// Inicializar banco de dados e servidor
AppDataSource.initialize()
  .then(async () => {
    console.log('✅ Banco de dados conectado com sucesso');

    // Executar migrações automaticamente
    try {
      console.log('🔄 Executando migrações...');
      await AppDataSource.runMigrations();
      console.log('✅ Migrações executadas com sucesso');
    } catch (migrationError) {
      console.warn('⚠️ Aviso ao executar migrações:', migrationError);
      // Não impede o servidor de iniciar, apenas avisa
    }

    app.listen(PORT, () => {
      console.log(`🚀 Servidor rodando na porta ${PORT}`);
      console.log(`📍 API disponível em http://localhost:${PORT}`);
    });
  })
  .catch((error) => {
    console.error('❌ Erro ao conectar com o banco de dados:', error);
    process.exit(1);
  });

// Tratamento de erros não capturados
process.on('unhandledRejection', (error) => {
  console.error('Unhandled Rejection:', error);
  process.exit(1);
});

