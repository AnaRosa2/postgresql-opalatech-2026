-- ==================================================
-- 10_joins.sql
-- JOINs principais
-- ==================================================

-- INNER JOIN:
-- Mostra apenas registros que possuem correspondência nas tabelas relacionadas.
SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    quartos.numero AS quarto,
    quartos.tipo AS tipo_quarto,
    reservas.valor_total
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
INNER JOIN quartos
ON reservas.numero_quarto = quartos.numero
ORDER BY reservas.id;


-- LEFT JOIN:
-- Mostra todos os hóspedes, mesmo que algum não tenha reserva.
SELECT
    hospedes.id,
    hospedes.nome,
    reservas.id AS reserva_id,
    reservas.data_entrada,
    reservas.data_saida
FROM hospedes
LEFT JOIN reservas
ON hospedes.id = reservas.hospede_id
ORDER BY hospedes.id;


-- RIGHT JOIN:
-- Mostra todas as reservas, mesmo que algum hóspede não aparecesse na tabela da esquerda.
SELECT
    hospedes.nome,
    reservas.id AS reserva_id,
    reservas.valor_total
FROM hospedes
RIGHT JOIN reservas
ON hospedes.id = reservas.hospede_id
ORDER BY reservas.id;


-- FULL JOIN:
-- Mostra todos os registros das duas tabelas, tendo correspondência ou não.
SELECT
    hospedes.nome,
    reservas.id AS reserva_id,
    reservas.valor_total
FROM hospedes
FULL JOIN reservas
ON hospedes.id = reservas.hospede_id
ORDER BY reservas.id;


-- JOIN com quatro tabelas:
-- Mostra hóspede, reserva, serviço consumido e valor do consumo.
SELECT
    hospedes.nome AS hospede,
    reservas.id AS reserva_id,
    servicos.descricao AS servico,
    consumos.quantidade,
    servicos.valor AS valor_unitario,
    consumos.quantidade * servicos.valor AS valor_total_consumo
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
INNER JOIN consumos
ON reservas.id = consumos.reserva_id
INNER JOIN servicos
ON consumos.servico_id = servicos.id
ORDER BY reservas.id;


-- LEFT JOIN com agregação:
-- Mostra todas as reservas e o total gasto em serviços.
SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    reservas.valor_total AS valor_reserva,
    COALESCE(SUM(consumos.quantidade * servicos.valor), 0) AS total_servicos
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
LEFT JOIN consumos
ON reservas.id = consumos.reserva_id
LEFT JOIN servicos
ON consumos.servico_id = servicos.id
GROUP BY reservas.id, hospedes.nome, reservas.valor_total
ORDER BY reservas.id;