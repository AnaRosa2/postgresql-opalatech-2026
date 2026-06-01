# Desafio Final — Hotel Opala Tech 2026

## Minicurso

**Introdução ao PostgreSQL para Aplicações Web**

Ministrantes:

* Nilson Rodrigo Borges de Sousa
* Ana Rosa Pereira Chaves

---

## Objetivo

Este desafio final foi preparado para revisar os principais conteúdos vistos no minicurso, usando a base de dados do projeto **Hotel Opala Tech 2026**.

O foco é praticar consultas SQL em um cenário simples de sistema de hotel, envolvendo hóspedes, quartos, reservas, serviços e consumos.

---

## Conteúdos revisados

Neste desafio, serão revisados:

* `SELECT`
* `WHERE`
* `ORDER BY`
* `LIMIT`
* Funções de agregação: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
* `GROUP BY`
* Chaves estrangeiras
* `INNER JOIN`
* `LEFT JOIN`
* Relatórios com múltiplas tabelas

---

## Importante sobre o tempo

Este minicurso tem duração limitada e acontece em um único dia.

Por isso, o desafio final foi dividido em duas partes:

1. **Prática guiada**: consultas que serão feitas durante o minicurso com acompanhamento dos ministrantes.
2. **Desafios extras**: consultas para o participante praticar depois, em casa.

Durante o minicurso, não é obrigatório resolver todas as consultas do arquivo `desafio_final.sql`.

---

## Importante sobre o Supabase

O arquivo `desafio_final.sql` foi pensado principalmente para consultas.

As práticas guiadas usam comandos seguros de consulta, como:

* `SELECT`
* `WHERE`
* `ORDER BY`
* `LIMIT`
* `COUNT`
* `GROUP BY`
* `JOIN`

Esses comandos não apagam nem alteram os dados da base.

---

## Arquivo utilizado

As consultas completas estão no arquivo:

```text
desafio_final.sql
```

---

## Tabelas utilizadas

A base do projeto possui as seguintes tabelas:

* `hospedes`
* `quartos`
* `reservas`
* `servicos`
* `consumos`

---

## Relações principais da base

```text
hospedes.id            -> reservas.hospede_id
quartos.numero         -> reservas.numero_quarto
reservas.id            -> consumos.reserva_id
servicos.id            -> consumos.servico_id
```

Essas relações permitem montar consultas envolvendo hóspedes, quartos reservados, serviços consumidos e valores finais de estadia.

---

## Parte 1 — Prática guiada durante o minicurso

Durante o minicurso, serão feitas as consultas marcadas como **PRÁTICA GUIADA** no arquivo `desafio_final.sql`.

Essas consultas foram escolhidas porque revisam os pontos principais sem comprometer o tempo da apresentação.

A prática guiada revisa:

1. Listagem de hóspedes;
2. Filtro de quartos livres;
3. Ordenação e limite de resultados;
4. Agrupamento de quartos por status;
5. Consulta com `INNER JOIN`;
6. Relatório final da estadia.

---

## Parte 2 — Desafios extras para casa

As consultas marcadas como **DESAFIO EXTRA** são atividades complementares.

Elas servem para o participante continuar praticando depois do minicurso.

Esses desafios extras envolvem:

* Seleção de colunas específicas;
* Filtros com `WHERE`;
* Ordenação com `ORDER BY`;
* Funções de agregação;
* Agrupamentos;
* Consultas com múltiplas tabelas;
* `LEFT JOIN`;
* Cálculo de totais;
* Relatório completo de estadia.

---

## Como executar

A ordem recomendada de execução dos arquivos SQL é:

```text
01_create_tables.sql
02_populacao_hotel.sql
03_select.sql
04_where_order_limit.sql
05_update_delete.sql
06_constraints.sql
07_agregacoes.sql
08_group_by.sql
09_foreign_keys.sql
10_joins.sql
desafio_final.sql
```

Os arquivos devem ser executados no **SQL Editor do Supabase** ou em outro ambiente PostgreSQL compatível.

---

## Resultado esperado

Ao concluir a prática guiada, o participante deverá entender como consultar dados simples e relacionados em PostgreSQL.

Ao concluir também os desafios extras, o participante terá praticado consultas mais completas, semelhantes às usadas em aplicações web reais.
