-- ==================================================
-- desafio_final.sql
-- HOTEL OPALA TECH 2026
-- Desafio final relacionado ao conteúdo do slide
-- Tema: Introdução ao PostgreSQL para Aplicações Web
-- ==================================================

-- Objetivo do desafio:
-- Revisar, de forma rápida e prática, os principais comandos vistos no minicurso:
-- SELECT, WHERE, ORDER BY, LIMIT, funções de agregação,
-- GROUP BY, FOREIGN KEY e JOINs.
--
-- IMPORTANTE:
-- Este arquivo foi pensado para um minicurso de apenas 3 horas.
-- Por isso, apenas as consultas marcadas como "PRÁTICA GUIADA"
-- devem ser feitas durante o minicurso.
--
-- As consultas marcadas como "DESAFIO EXTRA" ficam para o participante
-- praticar depois, em casa, se quiser continuar estudando.
--
-- Sugestão de uso durante o minicurso:
-- 15 a 25 minutos no final da parte prática.

-- ==================================================
-- PARTE 1
-- PRÁTICA GUIADA PARA FAZER DURANTE O MINICURSO
-- ==================================================


-- ==================================================
-- PRÁTICA GUIADA 1
-- SELECT básico
-- Liste todos os hóspedes cadastrados.
-- Relacionado ao slide: SELECT - consultando dados
-- ==================================================

SELECT *
FROM hospedes;


-- ==================================================
-- PRÁTICA GUIADA 2
-- WHERE
-- Liste apenas os quartos que estão livres.
-- Relacionado ao slide: WHERE - filtrando resultados
-- ==================================================

SELECT
    numero,
    tipo,
    valor_diaria,
    status
FROM quartos
WHERE status = 'Livre';


-- ==================================================
-- PRÁTICA GUIADA 3
-- ORDER BY + LIMIT
-- Mostre os 5 hóspedes em ordem alfabética.
-- Relacionado ao slide: ORDER BY e LIMIT
-- ==================================================

SELECT
    id,
    nome,
    telefone,
    email
FROM hospedes
ORDER BY nome ASC
LIMIT 5;


-- ==================================================
-- PRÁTICA GUIADA 4
-- GROUP BY
-- Conte a quantidade de quartos por status.
-- Relacionado ao slide: GROUP BY - agrupando dados
-- ==================================================

SELECT
    status,
    COUNT(*) AS quantidade_quartos
FROM quartos
GROUP BY status
ORDER BY quantidade_quartos DESC;


-- ==================================================
-- PRÁTICA GUIADA 5
-- FOREIGN KEY + INNER JOIN
-- Mostre as reservas com o nome do hóspede e o quarto reservado.
-- Relacionado aos slides: Foreign Key, Diagrama ER e JOIN
-- ==================================================

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


-- ==================================================
-- PRÁTICA GUIADA 6
-- Relatório final do projeto
-- Mostre o valor da reserva, o total gasto em serviços
-- e o valor total da estadia.
-- Relacionado ao projeto final do minicurso
-- ==================================================

SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    quartos.numero AS quarto,
    quartos.tipo AS tipo_quarto,
    reservas.valor_total AS valor_reserva,
    COALESCE(SUM(consumos.quantidade * servicos.valor), 0) AS total_servicos,
    reservas.valor_total + COALESCE(SUM(consumos.quantidade * servicos.valor), 0) AS total_estadia
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
INNER JOIN quartos
ON reservas.numero_quarto = quartos.numero
LEFT JOIN consumos
ON reservas.id = consumos.reserva_id
LEFT JOIN servicos
ON consumos.servico_id = servicos.id
GROUP BY
    reservas.id,
    hospedes.nome,
    quartos.numero,
    quartos.tipo,
    reservas.valor_total
ORDER BY total_estadia DESC;


-- ==================================================
-- PARTE 2
-- DESAFIOS EXTRAS PARA PRATICAR DEPOIS DO MINICURSO
-- ==================================================


-- ==================================================
-- DESAFIO EXTRA 1
-- SELECT escolhendo colunas específicas
-- Liste nome, CPF e e-mail dos hóspedes.
-- Relacionado ao slide: SELECT - consultando dados
-- ==================================================

SELECT
    nome,
    cpf,
    email
FROM hospedes;


-- ==================================================
-- DESAFIO EXTRA 2
-- WHERE + ORDER BY
-- Liste os quartos que não estão ocupados,
-- ordenando do mais caro para o mais barato.
-- Relacionado aos slides: WHERE, ORDER BY
-- ==================================================

SELECT
    numero,
    tipo,
    valor_diaria,
    status
FROM quartos
WHERE status <> 'Ocupado'
ORDER BY valor_diaria DESC;


-- ==================================================
-- DESAFIO EXTRA 3
-- Função de agregação COUNT
-- Conte quantos hóspedes existem cadastrados.
-- Relacionado ao slide: Funções de agregação - COUNT
-- ==================================================

SELECT
    COUNT(*) AS total_hospedes
FROM hospedes;


-- ==================================================
-- DESAFIO EXTRA 4
-- Funções de agregação SUM, AVG, MIN e MAX
-- Mostre o total, a média, o menor e o maior valor das reservas.
-- Relacionado ao slide: Funções de agregação
-- ==================================================

SELECT
    SUM(valor_total) AS total_reservas,
    AVG(valor_total) AS media_reservas,
    MIN(valor_total) AS menor_reserva,
    MAX(valor_total) AS maior_reserva
FROM reservas;


-- ==================================================
-- DESAFIO EXTRA 5
-- GROUP BY com média
-- Mostre a média do valor da diária por tipo de quarto.
-- Relacionado ao slide: GROUP BY - agrupando dados
-- ==================================================

SELECT
    tipo,
    AVG(valor_diaria) AS media_valor_diaria
FROM quartos
GROUP BY tipo
ORDER BY media_valor_diaria DESC;


-- ==================================================
-- DESAFIO EXTRA 6
-- INNER JOIN
-- Liste os consumos mostrando o serviço, quantidade e valor total.
-- Relacionado ao slide: JOIN - consultando dados de múltiplas tabelas
-- ==================================================

SELECT
    consumos.id AS consumo_id,
    servicos.descricao AS servico,
    consumos.quantidade,
    servicos.valor AS valor_unitario,
    consumos.quantidade * servicos.valor AS valor_total_consumo
FROM consumos
INNER JOIN servicos
ON consumos.servico_id = servicos.id
ORDER BY consumos.id;


-- ==================================================
-- DESAFIO EXTRA 7
-- JOIN com várias tabelas
-- Mostre um relatório com hóspede, quarto, reserva e serviço consumido.
-- Relacionado aos slides: Diagrama ER e JOIN
-- ==================================================

SELECT
    hospedes.nome AS hospede,
    quartos.numero AS quarto,
    quartos.tipo AS tipo_quarto,
    reservas.data_entrada,
    reservas.data_saida,
    servicos.descricao AS servico,
    consumos.quantidade,
    servicos.valor AS valor_unitario,
    consumos.quantidade * servicos.valor AS valor_total_servico
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
INNER JOIN quartos
ON reservas.numero_quarto = quartos.numero
INNER JOIN consumos
ON reservas.id = consumos.reserva_id
INNER JOIN servicos
ON consumos.servico_id = servicos.id
ORDER BY hospedes.nome;


-- ==================================================
-- DESAFIO EXTRA 8
-- LEFT JOIN
-- Liste todos os hóspedes e suas reservas,
-- mesmo que algum hóspede não tenha reserva.
-- Relacionado ao slide: LEFT JOIN vs INNER JOIN
-- ==================================================

SELECT
    hospedes.id AS hospede_id,
    hospedes.nome AS hospede,
    reservas.id AS reserva_id,
    reservas.data_entrada,
    reservas.data_saida,
    reservas.valor_total
FROM hospedes
LEFT JOIN reservas
ON hospedes.id = reservas.hospede_id
ORDER BY hospedes.id;


-- ==================================================
-- DESAFIO EXTRA 9
-- GROUP BY + JOIN
-- Mostre quanto cada hóspede gastou em reservas.
-- Relacionado aos slides: GROUP BY e JOIN
-- ==================================================

SELECT
    hospedes.nome AS hospede,
    SUM(reservas.valor_total) AS total_gasto_reservas
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
GROUP BY hospedes.nome
ORDER BY total_gasto_reservas DESC;


-- ==================================================
-- DESAFIO EXTRA 10
-- Pergunta final para os participantes:
-- Qual hóspede teve o maior valor total de estadia,
-- considerando reserva + serviços consumidos?
-- ==================================================

SELECT
    hospedes.nome AS hospede,
    SUM(
        reservas.valor_total + COALESCE(valor_servicos.total_servicos, 0)
    ) AS total_geral
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
LEFT JOIN (
    SELECT
        consumos.reserva_id,
        SUM(consumos.quantidade * servicos.valor) AS total_servicos
    FROM consumos
    INNER JOIN servicos
    ON consumos.servico_id = servicos.id
    GROUP BY consumos.reserva_id
) AS valor_servicos
ON reservas.id = valor_servicos.reserva_id
GROUP BY hospedes.nome
ORDER BY total_geral DESC
LIMIT 1;