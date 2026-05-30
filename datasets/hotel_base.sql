-- ==================================================
-- HOTEL OPALA TECH 2026
-- Base reduzida para minicurso PostgreSQL
-- Adaptada da base utilizada na disciplina
-- Banco de Dados II
-- ==================================================

-- ==========================================
-- LIMPEZA DAS TABELAS
-- ==========================================

-- CASCADE garante que a tabela seja removida mesmo que existam
-- relacionamentos (chaves estrangeiras) dependentes dela.
-- Facilita recriar toda a base durante testes e exercícios.

DROP TABLE IF EXISTS consumos CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS servicos CASCADE;
DROP TABLE IF EXISTS quartos CASCADE;
DROP TABLE IF EXISTS hospedes CASCADE;

-- ==========================================
-- TABELA: HOSPEDES
-- ==========================================

CREATE TABLE hospedes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

-- ==========================================
-- TABELA: QUARTOS
-- ==========================================

CREATE TABLE quartos (
    numero SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- ==========================================
-- TABELA: RESERVAS
-- ==========================================

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

-- ==========================================
-- TABELA: SERVICOS
-- ==========================================

CREATE TABLE servicos (
    id SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

-- ==========================================
-- TABELA: CONSUMOS
-- ==========================================

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

-- ==========================================
-- DADOS: HOSPEDES
-- ==========================================

INSERT INTO hospedes
(nome, cpf, data_nascimento, telefone, email)
VALUES
('Júlio Pereira', '001.001.001-01', '1970-11-24', '(86) 99636-5506', 'hospede1@email.com'),
('Felipe Costa', '002.002.002-02', '1984-02-18', '(86) 99306-4736', 'hospede2@email.com'),
('Lorena Rodrigues', '003.003.003-03', '1994-04-16', '(86) 99063-7858', 'hospede3@email.com'),
('Mônica Moura', '004.004.004-04', '1978-12-09', '(86) 99773-6006', 'hospede4@email.com'),
('Carla Silva', '005.005.005-05', '1975-01-27', '(86) 99167-4511', 'hospede5@email.com'),
('Bianca Campos', '006.006.006-06', '1998-10-17', '(86) 99495-8067', 'hospede6@email.com'),
('Vinícius Correia', '007.007.007-07', '1974-04-22', '(86) 99511-7837', 'hospede7@email.com'),
('Bianca Correia', '008.008.008-08', '1973-01-19', '(86) 98652-4593', 'hospede8@email.com'),
('Carlos Borges', '009.009.009-09', '1986-09-21', '(86) 98367-7298', 'hospede9@email.com'),
('Pedro Vieira', '010.010.010-10', '1984-09-28', '(86) 98666-3771', 'hospede10@email.com');

-- ==========================================
-- DADOS: QUARTOS
-- ==========================================

INSERT INTO quartos
(tipo, valor_diaria, status)
VALUES
('Solteiro', 400.00, 'Manutenção'),
('Solteiro', 150.00, 'Livre'),
('Duplo', 150.00, 'Livre'),
('Duplo', 400.00, 'Manutenção'),
('Luxo', 150.00, 'Manutenção'),
('Solteiro', 150.00, 'Livre'),
('Luxo', 200.00, 'Manutenção'),
('Solteiro', 200.00, 'Ocupado'),
('Duplo', 200.00, 'Ocupado'),
('Duplo', 200.00, 'Ocupado');

-- ==========================================
-- DADOS: SERVICOS
-- ==========================================

INSERT INTO servicos
(descricao, valor)
VALUES
('Café da manhã', 142.00),
('Almoço', 144.00),
('Jantar', 130.00),
('Serviço de quarto', 144.00),
('Lavanderia', 169.00);

-- ==========================================
-- DADOS: RESERVAS
-- ==========================================

INSERT INTO reservas
(hospede_id, numero_quarto, data_entrada, data_saida, valor_total)
VALUES
(1, 2, '2023-12-22', '2023-12-24', 1418.00),
(2, 4, '2023-09-24', '2023-09-26', 1434.00),
(3, 1, '2023-10-09', '2023-10-13', 425.00),
(4, 9, '2023-04-28', '2023-05-03', 1036.00),
(5, 8, '2023-04-17', '2023-04-22', 2000.00),
(6, 10, '2023-10-06', '2023-10-11', 1647.00),
(7, 3, '2023-11-06', '2023-11-10', 787.00),
(8, 7, '2023-09-29', '2023-10-01', 1219.00),
(9, 5, '2023-10-20', '2023-10-22', 1922.00),
(10, 6, '2023-11-14', '2023-11-19', 994.00);

-- ==========================================
-- DADOS: CONSUMOS
-- ==========================================

INSERT INTO consumos
(reserva_id, servico_id, quantidade)
VALUES
(1, 1, 2),
(2, 2, 1),
(3, 5, 3),
(4, 3, 2),
(5, 4, 1),
(6, 1, 2),
(7, 5, 1),
(8, 2, 3),
(9, 3, 1),
(10, 4, 2);

-- ==========================================
-- FIM DA BASE
-- ==========================================