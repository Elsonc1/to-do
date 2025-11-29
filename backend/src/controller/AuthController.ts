import { Request, Response } from 'express';
import { AuthService } from '../service/AuthService';

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  async register(req: Request, res: Response): Promise<void> {
    try {
      const { email, password, nome } = req.body;

      if (!email || !password || !nome) {
        res.status(400).json({ error: 'Email, senha e nome são obrigatórios' });
        return;
      }

      const result = await this.authService.register({ email, password, nome });

      res.status(201).json(result);
    } catch (error: any) {
      console.error('Erro ao registrar usuário:', error);
      
      if (error.message === 'Email já está em uso') {
        res.status(409).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Erro interno do servidor' });
      }
    }
  }

  async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        res.status(400).json({ error: 'Email e senha são obrigatórios' });
        return;
      }

      const result = await this.authService.login({ email, password });

      res.json(result);
    } catch (error: any) {
      console.error('Erro ao fazer login:', error);
      
      if (error.message === 'Email ou senha inválidos') {
        res.status(401).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Erro interno do servidor' });
      }
    }
  }
}

