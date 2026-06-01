-- ==================================================
-- 08_group_by.sql
-- GROUP BY
-- ==================================================

-- Contar quartos por tipo
SELECT
    tipo,
    COUNT(*) AS quantidade_quartos
FROM quartos
GROUP BY tipo;

-- Contar quartos por status
SELECT
    status,
    COUNT(*) AS quantidade_quartos
FROM quartos
GROUP BY status;

-- Calcular a média da diária por tipo de quarto
SELECT
    tipo,
    AVG(valor_diaria) AS media_diaria
FROM quartos
GROUP BY tipo;

-- Calcular o maior valor de diária por tipo de quarto
SELECT
    tipo,
    MAX(valor_diaria) AS maior_diaria
FROM quartos
GROUP BY tipo;

-- Calcular o total de reservas por quarto
SELECT
    numero_quarto,
    COUNT(*) AS total_reservas
FROM reservas
GROUP BY numero_quarto;

-- Calcular o total de reservas por hóspede
SELECT
    hospede_id,
    COUNT(*) AS total_reservas
FROM reservas
GROUP BY hospede_id;

-- Somar o valor total das reservas por hóspede
SELECT
    hospede_id,
    SUM(valor_total) AS total_gasto_reservas
FROM reservas
GROUP BY hospede_id;

-- Contar quantas vezes cada serviço foi consumido
SELECT
    servico_id,
    SUM(quantidade) AS quantidade_total_consumida
FROM consumos
GROUP BY servico_id;

-- Calcular o total arrecadado por serviço
SELECT
    servicos.descricao,
    SUM(consumos.quantidade * servicos.valor) AS total_arrecadado
FROM consumos
INNER JOIN servicos
ON consumos.servico_id = servicos.id
GROUP BY servicos.descricao;