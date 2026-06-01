-- ==================================================
-- 06_constraints.sql
-- Exemplos de NOT NULL, UNIQUE e FOREIGN KEY
-- ==================================================

-- A tabela hospedes usa NOT NULL nos campos:
-- nome, cpf e data_nascimento.

-- Exemplo válido respeitando NOT NULL:
INSERT INTO hospedes
(nome, cpf, data_nascimento, telefone, email)
VALUES
('Teste Constraint', '011.011.011-11', '2000-01-01', '(86) 98888-1111', 'teste@email.com');

-- Exemplo de NOT NULL que geraria erro se fosse executado:
-- O campo nome não pode receber NULL.
-- INSERT INTO hospedes
-- (nome, cpf, data_nascimento, telefone, email)
-- VALUES
-- (NULL, '012.012.012-12', '2000-01-01', '(86) 98888-2222', 'erro@email.com');


-- A tabela hospedes usa UNIQUE no campo cpf.

-- Exemplo de UNIQUE que geraria erro se fosse executado:
-- O CPF '001.001.001-01' já existe na tabela hospedes.
-- INSERT INTO hospedes
-- (nome, cpf, data_nascimento, telefone, email)
-- VALUES
-- ('CPF Repetido', '001.001.001-01', '1999-05-10', '(86) 98888-3333', 'cpfrepetido@email.com');


-- A tabela reservas usa FOREIGN KEY em:
-- hospede_id, referenciando hospedes(id)
-- numero_quarto, referenciando quartos(numero)

-- Exemplo válido respeitando FOREIGN KEY:
INSERT INTO reservas
(hospede_id, numero_quarto, data_entrada, data_saida, valor_total)
VALUES
(1, 3, '2024-01-10', '2024-01-12', 300.00);

-- Exemplo de FOREIGN KEY que geraria erro se fosse executado:
-- O hóspede 999 não existe na tabela hospedes.
-- INSERT INTO reservas
-- (hospede_id, numero_quarto, data_entrada, data_saida, valor_total)
-- VALUES
-- (999, 3, '2024-01-10', '2024-01-12', 300.00);


-- A tabela consumos usa FOREIGN KEY em:
-- reserva_id, referenciando reservas(id)
-- servico_id, referenciando servicos(id)

-- Exemplo válido respeitando FOREIGN KEY:
INSERT INTO consumos
(reserva_id, servico_id, quantidade)
VALUES
(1, 1, 1);

-- Exemplo de FOREIGN KEY que geraria erro se fosse executado:
-- O serviço 999 não existe na tabela servicos.
-- INSERT INTO consumos
-- (reserva_id, servico_id, quantidade)
-- VALUES
-- (1, 999, 2);