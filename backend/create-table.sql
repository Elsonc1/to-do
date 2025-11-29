-- Criar tipo enum apenas se não existir
DO $$ BEGIN
    CREATE TYPE task_status_enum AS ENUM ('pendente', 'em_andamento', 'concluida');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Criar tabela tasks apenas se não existir
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    status task_status_enum DEFAULT 'pendente',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_conclusao TIMESTAMP
);

