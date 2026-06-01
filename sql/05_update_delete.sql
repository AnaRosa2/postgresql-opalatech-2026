-- ==================================================
-- 05_update_delete.sql
-- UPDATE e DELETE
-- ATENÇÃO: este arquivo altera dados da base.
-- ==================================================

-- Atualizar o telefone de um hóspede
UPDATE hospedes
SET telefone = '(86) 99999-0001'
WHERE id = 1;

-- Atualizar o e-mail de um hóspede
UPDATE hospedes
SET email = 'julio.pereira@email.com'
WHERE id = 1;

-- Atualizar o status de um quarto
UPDATE quartos
SET status = 'Ocupado'
WHERE numero = 2;

-- Atualizar o valor da diária dos quartos de luxo
UPDATE quartos
SET valor_diaria = 250.00
WHERE tipo = 'Luxo';

-- Atualizar o valor de um serviço
UPDATE servicos
SET valor = 150.00
WHERE descricao = 'Café da manhã';

-- Excluir primeiro o consumo ligado à reserva 10
DELETE FROM consumos
WHERE reserva_id = 10;

-- Depois excluir a reserva 10
DELETE FROM reservas
WHERE id = 10;

-- Excluir um serviço que não esteja sendo usado em consumos
DELETE FROM servicos
WHERE descricao = 'Lavanderia'
AND id NOT IN (
    SELECT servico_id
    FROM consumos
);