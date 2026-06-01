-- ==================================================
-- 04_where_order_limit.sql
-- WHERE, ORDER BY e LIMIT
-- ==================================================

-- Listar quartos com diária maior que 200
SELECT numero, tipo, valor_diaria, status
FROM quartos
WHERE valor_diaria > 200;

-- Listar quartos que estão livres
SELECT numero, tipo, valor_diaria, status
FROM quartos
WHERE status = 'Livre';

-- Listar quartos que não estão ocupados
SELECT numero, tipo, valor_diaria, status
FROM quartos
WHERE status <> 'Ocupado';

-- Listar hóspedes cujo nome começa com a letra B
SELECT id, nome, telefone, email
FROM hospedes
WHERE nome LIKE 'B%';

-- Listar reservas com valor total maior ou igual a 1000
SELECT id, hospede_id, numero_quarto, data_entrada, data_saida, valor_total
FROM reservas
WHERE valor_total >= 1000;

-- Listar quartos ordenados do mais barato para o mais caro
SELECT numero, tipo, valor_diaria, status
FROM quartos
ORDER BY valor_diaria ASC;

-- Listar quartos ordenados do mais caro para o mais barato
SELECT numero, tipo, valor_diaria, status
FROM quartos
ORDER BY valor_diaria DESC;

-- Listar as 5 reservas de maior valor
SELECT id, hospede_id, numero_quarto, valor_total
FROM reservas
ORDER BY valor_total DESC
LIMIT 5;

-- Listar os 3 serviços mais caros
SELECT id, descricao, valor
FROM servicos
ORDER BY valor DESC
LIMIT 3;

-- Combinação de WHERE, ORDER BY e LIMIT
SELECT numero, tipo, valor_diaria, status
FROM quartos
WHERE status <> 'Ocupado'
ORDER BY valor_diaria DESC
LIMIT 5;