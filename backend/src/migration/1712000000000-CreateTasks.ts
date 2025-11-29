import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class CreateTasks1712000000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Criar tipo enum para status apenas se não existir
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE task_status_enum AS ENUM ('pendente', 'em_andamento', 'concluida');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    await queryRunner.createTable(
      new Table({
        name: 'tasks',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()'
          },
          {
            name: 'titulo',
            type: 'varchar',
            length: '255',
            isNullable: false
          },
          {
            name: 'descricao',
            type: 'text',
            isNullable: true
          },
          {
            name: 'status',
            type: 'enum',
            enum: ['pendente', 'em_andamento', 'concluida'],
            enumName: 'task_status_enum',
            default: "'pendente'"
          },
          {
            name: 'data_criacao',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP'
          },
          {
            name: 'data_conclusao',
            type: 'timestamp',
            isNullable: true
          }
        ]
      }),
      true
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('tasks');
    await queryRunner.query(`DROP TYPE IF EXISTS task_status_enum`);
  }
}

