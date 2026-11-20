-- =====================================================================
-- TRAJELOC - Consultas SQL (DQL) - entrega final de BD (E2)
-- Rodar depois do DDL e do DML.
-- =====================================================================
USE trajeloc;

-- C1. JOIN + ORDER BY
-- Agenda de locações: cliente, atendente, peças e datas, em ordem de evento.
SELECT l.id_locacao,
       c.nome                                                   AS cliente,
       f.nome                                                   AS atendente,
       GROUP_CONCAT(p.codigo_unico ORDER BY p.codigo_unico SEPARATOR ', ') AS pecas,
       l.data_evento,
       l.data_devolucao,
       l.status
FROM locacao l
JOIN cliente      c  ON c.id_cliente     = l.id_cliente
JOIN funcionario  f  ON f.id_funcionario = l.id_funcionario
JOIN item_locacao il ON il.id_locacao    = l.id_locacao
JOIN peca_produto p  ON p.id_peca        = il.id_peca
GROUP BY l.id_locacao, c.nome, f.nome, l.data_evento, l.data_devolucao, l.status
ORDER BY l.data_evento;

-- C2. WHERE + JOIN
-- Reservas a partir de 19/11/2026 (o que a loja precisa preparar).
SELECT l.data_evento,
       c.nome          AS cliente,
       c.telefone,
       p.codigo_unico,
       p.descricao     AS peca
FROM locacao l
JOIN cliente      c  ON c.id_cliente  = l.id_cliente
JOIN item_locacao il ON il.id_locacao = l.id_locacao
JOIN peca_produto p  ON p.id_peca     = il.id_peca
WHERE l.status = 'RESERVADA'
  AND l.data_evento >= '2026-11-19'
ORDER BY l.data_evento, p.codigo_unico;

-- C3. Atributo derivado calculado na consulta + subconsulta
-- Valor total de cada locação (soma dos itens), quanto já foi pago e o saldo.
SELECT l.id_locacao,
       c.nome                                         AS cliente,
       SUM(il.preco_aluguel)                          AS valor_total,
       (SELECT COALESCE(SUM(pg.valor), 0)
          FROM pagamento pg
         WHERE pg.id_locacao = l.id_locacao)          AS valor_pago,
       SUM(il.preco_aluguel) + l.multa
         - (SELECT COALESCE(SUM(pg.valor), 0)
              FROM pagamento pg
             WHERE pg.id_locacao = l.id_locacao)      AS saldo_a_receber
FROM locacao l
JOIN cliente      c  ON c.id_cliente  = l.id_cliente
JOIN item_locacao il ON il.id_locacao = l.id_locacao
GROUP BY l.id_locacao, c.nome, l.multa
ORDER BY saldo_a_receber DESC;

-- C4. GROUP BY + HAVING
-- Peças alugadas mais de uma vez e quanto renderam (apoio à decisão de compra e bazar).
SELECT p.codigo_unico,
       p.descricao,
       COUNT(*)              AS vezes_alugada,
       SUM(il.preco_aluguel) AS receita
FROM item_locacao il
JOIN peca_produto p ON p.id_peca = il.id_peca
GROUP BY p.id_peca, p.codigo_unico, p.descricao
HAVING COUNT(*) > 1
ORDER BY vezes_alugada DESC, receita DESC;

-- C5. Subconsulta com NOT EXISTS (regra de bloqueio por período)
-- Peças livres para um evento em 05/12/2026 (retirada 04/12, devolução 07/12):
-- não aparecem as peças com locação cujo período se sobrepõe.
SELECT p.codigo_unico, p.descricao, p.tamanho, p.cor, p.preco
FROM peca_produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM item_locacao il
    JOIN locacao l ON l.id_locacao = il.id_locacao
    WHERE il.id_peca = p.id_peca
      AND l.data_entrega <= '2026-12-07'
      AND COALESCE(l.data_devolucao, l.data_evento) >= '2026-12-04'
)
ORDER BY p.codigo_unico;

-- C6. GROUP BY por mês + agregação
-- Faturamento previsto por mês do evento (soma dos itens).
SELECT DATE_FORMAT(l.data_evento, '%Y-%m') AS mes,
       COUNT(DISTINCT l.id_locacao)        AS locacoes,
       SUM(il.preco_aluguel)               AS faturamento
FROM locacao l
JOIN item_locacao il ON il.id_locacao = l.id_locacao
GROUP BY DATE_FORMAT(l.data_evento, '%Y-%m')
ORDER BY mes;

-- C7. GROUP BY + função de agregação + JOIN
-- Atendimentos por funcionário ativo.
SELECT f.nome            AS funcionario,
       COUNT(l.id_locacao) AS atendimentos
FROM funcionario f
LEFT JOIN locacao l ON l.id_funcionario = f.id_funcionario
WHERE f.ativo = TRUE
GROUP BY f.id_funcionario, f.nome
ORDER BY atendimentos DESC, f.nome;
