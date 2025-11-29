const { AppDataSource } = require('../dist/data-source');

async function runMigrations() {
  try {
    console.log('Conectando ao banco de dados...');
    await AppDataSource.initialize();
    
    console.log('Executando migrações...');
    const migrations = await AppDataSource.runMigrations();
    
    if (migrations.length > 0) {
      console.log(`${migrations.length} migração(ões) executada(s):`);
      migrations.forEach(migration => {
        console.log(`   - ${migration.name}`);
      });
    } else {
      console.log('Nenhuma migração pendente. Todas já foram executadas.');
    }
    
    await AppDataSource.destroy();
    process.exit(0);
  } catch (error) {
    console.error('Erro ao executar migrações:', error);
    process.exit(1);
  }
}

runMigrations();

