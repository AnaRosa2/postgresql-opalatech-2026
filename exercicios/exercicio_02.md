# Exercício 02 — Relacionamentos entre Tabelas

## Minicurso

**Introdução ao PostgreSQL para Aplicações Web**

---

## Objetivo

Este exercício tem como objetivo praticar consultas envolvendo tabelas relacionadas.

Ele está ligado ao bloco de **modelagem relacional**, **chaves estrangeiras** e **JOINs** do minicurso.

---

## Conteúdos praticados

Neste exercício, serão praticados:

* Chave primária;
* Chave estrangeira;
* Relacionamento entre tabelas;
* `INNER JOIN`;
* `LEFT JOIN`;
* `GROUP BY`;
* Consultas com várias tabelas.

---

## Observação sobre o tempo

Como o minicurso tem apenas 3 horas, este exercício será feito de forma guiada.

Durante a aula, serão resolvidas apenas as consultas principais.

As demais questões ficam como prática extra para depois.

---

## Observação sobre o Supabase

Este exercício pode ser executado diretamente no **SQL Editor do Supabase**, desde que as tabelas já tenham sido criadas e populadas.

As consultas principais usam `SELECT`, `INNER JOIN`, `LEFT JOIN` e `GROUP BY`.

Esses comandos apenas consultam os dados e não apagam nem alteram registros da base.

---

## Tabelas utilizadas

A base do projeto possui as seguintes tabelas:

* `hospedes`
* `quartos`
* `reservas`
* `servicos`
* `consumos`

---

## Relações principais

```text
hospedes.id            -> reservas.hospede_id
quartos.numero         -> reservas.numero_quarto
reservas.id            -> consumos.reserva_id
servicos.id            -> consumos.servico_id
```

Essas relações permitem consultar informações completas sobre reservas, hóspedes, quartos e serviços consumidos.

---

# Parte 1 — Prática guiada durante o minicurso

## 1. Visualizar as reservas com seus IDs relacionados

Antes de usar `JOIN`, observe que a tabela `reservas` guarda IDs de outras tabelas.

```sql
SELECT
    id,
    hospede_id,
    numero_quarto,
    data_entrada,
    data_saida,
    valor_total
FROM reservas;
```

---

## 2. Mostrar reservas com o nome do hóspede

Aqui usamos `INNER JOIN` para ligar `reservas` com `hospedes`.

```sql
SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    reservas.data_entrada,
    reservas.data_saida,
    reservas.valor_total
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
ORDER BY reservas.id;
```

---

## 3. Mostrar reservas com nome do hóspede e quarto reservado

Aqui ligamos três tabelas: `reservas`, `hospedes` e `quartos`.

```sql
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
```

---

## 4. Mostrar os consumos com serviço, quantidade e valor total

Aqui ligamos `consumos` com `servicos`.

```sql
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
```

---

## 5. Gerar relatório final da estadia

Esta consulta reúne hóspedes, quartos, reservas, consumos e serviços.

```sql
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
```

---

# Parte 2 — Desafios extras para praticar depois

Resolva depois do minicurso:

## Desafio extra 1

Liste todos os hóspedes e suas reservas usando `LEFT JOIN`.

Sugestão:

```sql
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
```

---

## Desafio extra 2

Mostre quanto cada hóspede gastou em reservas.

Sugestão:

```sql
SELECT
    hospedes.nome AS hospede,
    SUM(reservas.valor_total) AS total_gasto_reservas
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
GROUP BY hospedes.nome
ORDER BY total_gasto_reservas DESC;
```

---

## Desafio extra 3

Mostre a quantidade de quartos por status.

Sugestão:

```sql
SELECT
    status,
    COUNT(*) AS quantidade_quartos
FROM quartos
GROUP BY status
ORDER BY quantidade_quartos DESC;
```

---

## Desafio extra 4

Mostre a média do valor da diária por tipo de quarto.

Sugestão:

```sql
SELECT
    tipo,
    AVG(valor_diaria) AS media_valor_diaria
FROM quartos
GROUP BY tipo
ORDER BY media_valor_diaria DESC;
```

---

## Desafio extra 5

Mostre o total gasto em serviços por reserva.

Sugestão:

```sql
SELECT
    reservas.id AS reserva_id,
    hospedes.nome AS hospede,
    SUM(consumos.quantidade * servicos.valor) AS total_servicos
FROM reservas
INNER JOIN hospedes
ON reservas.hospede_id = hospedes.id
INNER JOIN consumos
ON reservas.id = consumos.reserva_id
INNER JOIN servicos
ON consumos.servico_id = servicos.id
GROUP BY reservas.id, hospedes.nome
ORDER BY total_servicos DESC;
```

---

## Desafio extra 6

Mostre qual serviço gerou mais dinheiro.

Sugestão:

```sql
SELECT
    servicos.descricao AS servico,
    SUM(consumos.quantidade * servicos.valor) AS total_arrecadado
FROM servicos
INNER JOIN consumos
ON servicos.id = consumos.servico_id
GROUP BY servicos.descricao
ORDER BY total_arrecadado DESC
LIMIT 1;
```

---

## Desafio extra 7

Mostre qual hóspede teve a reserva de maior valor.

Sugestão:

```sql
SELECT
    hospedes.nome AS hospede,
    reservas.valor_total
FROM hospedes
INNER JOIN reservas
ON hospedes.id = reservas.hospede_id
ORDER BY reservas.valor_total DESC
LIMIT 1;
```

---

## Desafio extra 8

Mostre o total geral arrecadado pelo hotel, considerando reservas e serviços.

Sugestão:

```sql
SELECT
    (
        SELECT SUM(valor_total)
        FROM reservas
    )
    +
    (
        SELECT SUM(consumos.quantidade * servicos.valor)
        FROM consumos
        INNER JOIN servicos
        ON consumos.servico_id = servicos.id
    ) AS total_geral_hotel;
```

---

## Desafio extra 9

Explique a diferença entre `INNER JOIN` e `LEFT JOIN`.

---

## Desafio extra 10

Explique por que as chaves estrangeiras ajudam a manter a integridade dos dados.

---

## Resultado esperado

Ao final deste exercício, o participante deverá entender como tabelas se relacionam em um banco de dados relacional.

O participante também deverá conseguir montar consultas que combinem informações de várias tabelas usando `JOIN`.

Esse conhecimento é essencial para aplicações web, pois sistemas reais normalmente armazenam seus dados em várias tabelas relacionadas.
