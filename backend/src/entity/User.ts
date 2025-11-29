import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email!: string;

  @Column({ type: 'varchar', length: 255 })
  password!: string; // Será hash da senha

  @Column({ type: 'varchar', length: 255 })
  nome!: string;

  @CreateDateColumn({ name: 'data_criacao' })
  dataCriacao!: Date;
}

