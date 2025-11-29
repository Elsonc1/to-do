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
    const existingUser = await this.userRepository.findOne({
      where: { email: data.email }
    });

    if (existingUser) {
      throw new Error('Email já está em uso');
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    const user = this.userRepository.create({
      email: data.email,
      password: hashedPassword,
      nome: data.nome
    });

    await this.userRepository.save(user);

    const token = this.generateToken(user.id);
    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword as User,
      token
    };
  }

  async login(data: LoginDTO): Promise<{ user: User; token: string }> {
    const user = await this.userRepository.findOne({
      where: { email: data.email }
    });

    if (!user) {
      throw new Error('Email ou senha inválidos');
    }

    const isValidPassword = await bcrypt.compare(data.password, user.password);

    if (!isValidPassword) {
      throw new Error('Email ou senha inválidos');
    }

    const token = this.generateToken(user.id);
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

