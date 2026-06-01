-- ==================================================
-- 07_agregacoes.sql
-- COUNT, SUM, AVG, MIN, MAX
-- ==================================================

-- Contar quantos hóspedes existem
SELECT COUNT(*) AS total_hospedes
FROM hospedes;

-- Contar quantos quartos existem
SELECT COUNT(*) AS total_quartos
FROM quartos;

-- Contar quantas reservas existem
SELECT COUNT(*) AS total_reservas
FROM reservas;

-- Somar o valor total de todas as reservas
SELECT SUM(valor_total) AS soma_valor_reservas
FROM reservas;

-- Calcular a média dos valores das reservas
SELECT AVG(valor_total) AS media_valor_reservas
FROM reservas;

-- Mostrar a menor diária dos quartos
SELECT MIN(valor_diaria) AS menor_diaria
FROM quartos;

-- Mostrar a maior diária dos quartos
SELECT MAX(valor_diaria) AS maior_diaria
FROM quartos;

-- Mostrar menor, maior e média das diárias
SELECT
    MIN(valor_diaria) AS menor_diaria,
    MAX(valor_diaria) AS maior_diaria,
    AVG(valor_diaria) AS media_diarias
FROM quartos;

-- Somar a quantidade total de serviços consumidos
SELECT SUM(quantidade) AS total_servicos_consumidos
FROM consumos;

-- Calcular o valor total dos consumos
SELECT
    SUM(consumos.quantidade * servicos.valor) AS valor_total_consumos
FROM consumos
INNER JOIN servicos
ON consumos.servico_id = servicos.id;