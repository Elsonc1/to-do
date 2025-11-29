import { Repository } from 'typeorm';
import { AppDataSource } from '../data-source';
import { User } from '../entity/User';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

interface RegisterDTO {
  email: string;
  password: string;
  nome: string;
}

interface LoginDTO {
  email: string;
  password: string;
}

export class AuthService {
  private userRepository: Repository<User>;

  constructor() {
    this.userRepository = AppDataSource.getRepository(User);
  }

  async register(data: RegisterDTO): Promise<{ user: User; token: string }> {
    // Verificar se email já existe
    const existingUser = await this.userRepository.findOne({
      where: { email: data.email }
    });

    if (existingUser) {
      throw new Error('Email já está em uso');
    }

    // Hash da senha
    const hashedPassword = await bcrypt.hash(data.password, 10);

    // Criar usuário
    const user = this.userRepository.create({
      email: data.email,
      password: hashedPassword,
      nome: data.nome
    });

    await this.userRepository.save(user);

    // Gerar token
    const token = this.generateToken(user.id);

    // Remover senha do objeto retornado
    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword as User,
      token
    };
  }

  async login(data: LoginDTO): Promise<{ user: User; token: string }> {
    // Buscar usuário
    const user = await this.userRepository.findOne({
      where: { email: data.email }
    });

    if (!user) {
      throw new Error('Email ou senha inválidos');
    }

    // Verificar senha
    const isValidPassword = await bcrypt.compare(data.password, user.password);

    if (!isValidPassword) {
      throw new Error('Email ou senha inválidos');
    }

    // Gerar token
    const token = this.generateToken(user.id);

    // Remover senha do objeto retornado
    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword as User,
      token
    };
  }

  private generateToken(userId: string): string {
    const secret = process.env.JWT_SECRET || 'seu-secret-aqui-mude-em-producao';
    return jwt.sign({ userId }, secret, { expiresIn: '7d' });
  }
}

