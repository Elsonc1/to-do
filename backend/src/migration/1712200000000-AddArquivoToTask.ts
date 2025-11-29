import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

export class AddArquivoToTask1712200000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.addColumn(
      'tasks',
      new TableColumn({
        name: 'arquivo',
        type: 'varchar',
        length: '500',
        isNullable: true
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('tasks', 'arquivo');
  }
}

