-- ==================================================
-- 09_foreign_keys.sql
-- Explicação e consulta das relações
-- ==================================================

-- RELAÇÕES DA BASE:
--
-- reservas.hospede_id      -> hospedes.id
-- reservas.numero_quarto   -> quartos.numero
-- consumos.reserva_id      -> reservas.id
-- consumos.servico_id      -> servicos.id


-- Consultar as chaves estrangeiras existentes no banco
SELECT
    tc.table_name AS tabela,
    kcu.column_name AS coluna_fk,
    ccu.table_name AS tabela_referenciada,
    ccu.column_name AS coluna_referenciada
FROM information_schema.table_constraints AS tc
INNER JOIN information_schema.key_column_usage AS kcu
ON tc.constraint_name = kcu.constraint_name
AND tc.table_schema = kcu.table_schema
INNER JOIN information_schema.constraint_column_usage AS ccu
ON ccu.constraint_name = tc.constraint_name
AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;


-- Mostrar reservas com o nome do hóspede e o quarto relacionado
SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    quartos.numero AS numero_quarto,
    quartos.tipo AS tipo_quarto,
    reservas.data_entrada,
    reservas.data_saida,
    reservas.valor_total
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
INNER JOIN quartos
ON reservas.numero_quarto = quartos.numero
ORDER BY reservas.id;


-- Mostrar consumos com a reserva e o serviço relacionado
SELECT
    consumos.id AS consumo_id,
    consumos.reserva_id,
    servicos.descricao AS servico,
    consumos.quantidade,
    servicos.valor AS valor_unitario,
    consumos.quantidade * servicos.valor AS valor_total_consumo
FROM consumos
INNER JOIN servicos
ON consumos.servico_id = servicos.id
ORDER BY consumos.id;