-- ==================================================
-- 03_select.sql
-- Exemplos básicos de SELECT
-- ==================================================

-- Listar todos os hóspedes
SELECT *
FROM hospedes;

-- Listar todos os quartos
SELECT *
FROM quartos;

-- Listar todos os serviços
SELECT *
FROM servicos;

-- Listar todos os dados das reservas
SELECT *
FROM reservas;

-- Listar todos os consumos
SELECT *
FROM consumos;

-- Selecionar apenas alguns campos dos hóspedes
SELECT nome, telefone, email
FROM hospedes;

-- Selecionar apenas número, tipo e valor da diária dos quartos
SELECT numero, tipo, valor_diaria
FROM quartos;

-- Usando alias para melhorar o nome das colunas
SELECT
    nome AS nome_hospede,
    cpf AS documento,
    telefone AS contato
FROM hospedes;