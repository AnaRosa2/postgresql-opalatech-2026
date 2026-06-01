# Exercício 01 — CRUD Básico

## Minicurso

**Introdução ao PostgreSQL para Aplicações Web**

---

## Objetivo

Este exercício tem como objetivo praticar os comandos básicos de SQL usados para inserir, consultar, atualizar e remover dados.

Ele está relacionado ao bloco **SQL na prática** do minicurso.

---

## Conteúdos praticados

Neste exercício, serão praticados:

* `INSERT INTO`
* `SELECT`
* `WHERE`
* `ORDER BY`
* `LIMIT`
* `UPDATE`
* `DELETE`

---

## Observação sobre o tempo

Como o minicurso tem apenas 3 horas, nem todas as questões deste exercício precisam ser resolvidas ao vivo.

Durante a aula, os ministrantes irão resolver a **parte guiada**.

As questões extras ficam para o participante praticar depois.

---

## Observação sobre o Supabase

Este exercício foi ajustado para ser usado no **SQL Editor do Supabase** com mais segurança.

O comando de inserção usa `ON CONFLICT (cpf) DO NOTHING`, para evitar erro caso o participante execute a mesma consulta mais de uma vez.

Os comandos de `UPDATE` usam o CPF do hóspede de teste, evitando alterar os hóspedes originais da base.

O comando de `DELETE` está comentado, para evitar apagar dados importantes durante o minicurso.

---

# Parte 1 — Prática guiada durante o minicurso

## 1. Inserir um novo hóspede de teste

```sql
INSERT INTO hospedes
(nome, cpf, data_nascimento, telefone, email)
VALUES
('João Silva', '123.456.789-00', '2000-05-15', '(86) 99999-1111', 'joao@email.com')
ON CONFLICT (cpf) DO NOTHING;
```

---

## 2. Listar todos os hóspedes cadastrados

```sql
SELECT *
FROM hospedes;
```

---

## 3. Listar apenas nome, CPF e e-mail dos hóspedes

```sql
SELECT
    nome,
    cpf,
    email
FROM hospedes;
```

---

## 4. Listar todos os quartos cadastrados

```sql
SELECT *
FROM quartos;
```

---

## 5. Listar apenas os quartos que estão livres

```sql
SELECT
    numero,
    tipo,
    valor_diaria,
    status
FROM quartos
WHERE status = 'Livre';
```

---

## 6. Mostrar os 5 hóspedes em ordem alfabética

```sql
SELECT
    id,
    nome,
    telefone,
    email
FROM hospedes
ORDER BY nome ASC
LIMIT 5;
```

---

## 7. Atualizar o telefone do hóspede de teste

Atenção: sempre use `WHERE` em comandos `UPDATE`.

```sql
UPDATE hospedes
SET telefone = '(86) 99999-8888'
WHERE cpf = '123.456.789-00';
```

---

## 8. Conferir se a atualização funcionou

```sql
SELECT *
FROM hospedes
WHERE cpf = '123.456.789-00';
```

---

## 9. Exemplo de DELETE

Atenção: o comando `DELETE` remove registros da tabela.

Durante o minicurso, este comando deve ser explicado com cuidado.

Por segurança, o comando abaixo está comentado. Ele serve apenas para demonstração.

```sql
-- DELETE FROM hospedes
-- WHERE cpf = '123.456.789-00';
```

---

## Atenção importante

Nunca execute um `DELETE` sem `WHERE`.

O comando abaixo removeria todos os hóspedes da tabela:

```sql
-- DELETE FROM hospedes;
```

Por isso, ele não deve ser executado durante a prática.

---

# Parte 2 — Desafios extras para praticar depois

Resolva depois do minicurso:

## Desafio extra 1

Liste todos os serviços cadastrados.

---

## Desafio extra 2

Liste os quartos que não estão ocupados.

---

## Desafio extra 3

Liste as reservas com valor total maior que 1000.

---

## Desafio extra 4

Liste os quartos ordenados do mais caro para o mais barato.

---

## Desafio extra 5

Mostre apenas os 3 serviços mais caros.

---

## Desafio extra 6

Insira um novo serviço na tabela `servicos`.

Sugestão:

```sql
INSERT INTO servicos
(descricao, valor)
VALUES
('Estacionamento', 50.00);
```

---

## Desafio extra 7

Atualize o status de um quarto para `Ocupado`.

Sugestão:

```sql
UPDATE quartos
SET status = 'Ocupado'
WHERE numero = 2;
```

---

## Desafio extra 8

Atualize o valor de um serviço.

Sugestão:

```sql
UPDATE servicos
SET valor = 90.00
WHERE descricao = 'Estacionamento';
```

---

## Desafio extra 9

Busque um hóspede pelo ID.

Sugestão:

```sql
SELECT *
FROM hospedes
WHERE id = 1;
```

---

## Desafio extra 10

Busque as reservas feitas por um determinado hóspede.

Sugestão:

```sql
SELECT *
FROM reservas
WHERE hospede_id = 1;
```

---

## Desafio extra 11

Explique, com suas palavras, por que comandos `UPDATE` e `DELETE` precisam de `WHERE`.

---

## Resultado esperado

Ao final deste exercício, o participante deverá entender a base do CRUD em SQL:

* Inserir dados com `INSERT INTO`;
* Consultar dados com `SELECT`;
* Filtrar dados com `WHERE`;
* Ordenar dados com `ORDER BY`;
* Limitar resultados com `LIMIT`;
* Atualizar registros com `UPDATE`;
* Remover registros com `DELETE`.

Esse conteúdo será usado no próximo exercício, que trabalha relacionamentos entre tabelas.
