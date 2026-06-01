-- ==================================================
-- 01_create_tables.sql
-- HOTEL OPALA TECH 2026
-- Apenas DROP + CREATE TABLE
-- ==================================================

DROP TABLE IF EXISTS consumos CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS servicos CASCADE;
DROP TABLE IF EXISTS quartos CASCADE;
DROP TABLE IF EXISTS hospedes CASCADE;

CREATE TABLE hospedes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE quartos (
    numero SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE reservas (
    id SERIAL PRIMARY KEY,
    hospede_id INTEGER NOT NULL,
    numero_quarto INTEGER NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida DATE NOT NULL,
    valor_total DECIMAL(10,2),

    FOREIGN KEY (hospede_id)
        REFERENCES hospedes(id),

    FOREIGN KEY (numero_quarto)
        REFERENCES quartos(numero)
);

CREATE TABLE servicos (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

CREATE TABLE consumos (
    id SERIAL PRIMARY KEY,
    reserva_id INTEGER NOT NULL,
    servico_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,

    FOREIGN KEY (reserva_id)
        REFERENCES reservas(id),

    FOREIGN KEY (servico_id)
        REFERENCES servicos(id)
);