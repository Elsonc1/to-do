import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

export enum TaskStatus {
  PENDENTE = 'pendente',
  EM_ANDAMENTO = 'em_andamento',
  CONCLUIDA = 'concluida'
}

@Entity('tasks')
export class Task {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', length: 255 })
  titulo!: string;

  @Column({ type: 'text', nullable: true })
  descricao?: string;

  @Column({
    type: 'enum',
    enum: TaskStatus,
    default: TaskStatus.PENDENTE
  })
  status!: TaskStatus;

  @CreateDateColumn({ name: 'data_criacao' })
  dataCriacao!: Date;

  @Column({ name: 'data_conclusao', type: 'timestamp', nullable: true })
  dataConclusao?: Date;

  @Column({ type: 'varchar', length: 500, nullable: true })
  arquivo?: string;
}

