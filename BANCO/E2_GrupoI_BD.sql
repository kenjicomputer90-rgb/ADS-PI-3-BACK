-- E2_GrupoI_BD.sql - TRAJELOC - Banco de Dados I - Entrega final (E2)
-- Grupo I: Eduardo Kenji Takemoto, Gabriel Reinardi Beletti da Silva, Guilherme Takeshi Pereira Oshiro, Jocilaine Araujo, Laerte Pereira dos Reis, Thais Rocha Silva
-- Conteúdo: DDL + DML + consultas. Rodar em uma instalação limpa do MySQL 8.

-- ===================== PARTE 1 - DDL =====================
-- =====================================================================
-- TRAJELOC - Sistema de gestão para loja de locação de trajes
-- Script DDL (MySQL 8) - versão revisada para a entrega final de BD (E2)
--
-- Mudanças em relação à versão anterior:
--   - removida a tabela administrador: o administrador é um usuário com
--     perfil_acesso = 'ADMINISTRADOR', sem dados próprios além dos do usuário;
--   - removida a coluna locacao.preco_total: é atributo derivado
--     (soma de item_locacao.preco_aluguel) e passa a ser calculado na consulta;
--   - datas sem hora passam de DATETIME para DATE;
--   - CPF em CHAR(14), tamanho fixo com a máscara 000.000.000-00,
--     que é o formato usado pelo sistema (back-end e telas).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS trajeloc
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE trajeloc;

-- 1. ACESSO
CREATE TABLE usuario (
    id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    senha          VARCHAR(255) NOT NULL,
    perfil_acesso  VARCHAR(50)  NOT NULL
);

-- 2. ACERVO
CREATE TABLE status_peca (
    id_status  INT AUTO_INCREMENT PRIMARY KEY,
    descricao  VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE peca_produto (
    id_peca       INT AUTO_INCREMENT PRIMARY KEY,
    codigo_unico  VARCHAR(50)   NOT NULL UNIQUE,
    descricao     VARCHAR(150)  NOT NULL,
    tamanho       VARCHAR(10)   NOT NULL,
    cor           VARCHAR(30)   NOT NULL,
    material      VARCHAR(50),
    preco         DECIMAL(10,2) NOT NULL,
    sexo          VARCHAR(20)
);

-- 3. ESPECIALIZAÇÕES DE USUÁRIO
CREATE TABLE cliente (
    id_cliente       INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario       INT UNIQUE,
    nome             VARCHAR(100) NOT NULL,
    cpf              CHAR(14)     NOT NULL UNIQUE,
    telefone         VARCHAR(20)  NOT NULL,
    endereco         VARCHAR(150) NOT NULL,
    rg               VARCHAR(20),
    medidas          TEXT,
    data_nascimento  DATE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE funcionario (
    id_funcionario   INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario       INT NOT NULL UNIQUE,
    nome             VARCHAR(100) NOT NULL,
    cpf              CHAR(14)     NOT NULL UNIQUE,
    rg               VARCHAR(20),
    telefone         VARCHAR(20),
    ctps             VARCHAR(20),
    dependente       INT NOT NULL DEFAULT 0,
    sexo             VARCHAR(20),
    salario          DECIMAL(10,2),
    data_nascimento  DATE,
    estado_civil     VARCHAR(30),
    ativo            BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. OPERAÇÕES DE NEGÓCIO
CREATE TABLE locacao (
    id_locacao      INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    id_usuario      INT NOT NULL,
    id_funcionario  INT NOT NULL,
    data_evento     DATE NOT NULL,
    data_entrega    DATE,
    data_devolucao  DATE,
    status          VARCHAR(30)   NOT NULL DEFAULT 'RESERVADA',
    multa           DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (id_cliente)     REFERENCES cliente(id_cliente)         ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario)     REFERENCES usuario(id_usuario)         ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pagamento (
    id_pagamento  INT AUTO_INCREMENT PRIMARY KEY,
    id_locacao    INT NOT NULL,
    valor         DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. ITENS, AJUSTES, MANUTENÇÃO E HISTÓRICO DA PEÇA
CREATE TABLE item_locacao (
    id_item        INT AUTO_INCREMENT PRIMARY KEY,
    id_locacao     INT NOT NULL,
    id_peca        INT NOT NULL,
    preco_aluguel  DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao)    ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (id_peca)    REFERENCES peca_produto(id_peca)  ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ajuste (
    id_ajuste  INT AUTO_INCREMENT PRIMARY KEY,
    id_item    INT  NOT NULL,
    descricao  TEXT NOT NULL,
    FOREIGN KEY (id_item) REFERENCES item_locacao(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE manutencao (
    id_manutencao    INT AUTO_INCREMENT PRIMARY KEY,
    id_peca          INT  NOT NULL,
    descricao        TEXT NOT NULL,
    data_manutencao  DATE NOT NULL,
    FOREIGN KEY (id_peca) REFERENCES peca_produto(id_peca) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historico_peca (
    id_historico  INT AUTO_INCREMENT PRIMARY KEY,
    id_peca       INT      NOT NULL,
    id_status     INT      NOT NULL,
    data_inicio   DATETIME NOT NULL,
    data_fim      DATETIME,
    FOREIGN KEY (id_peca)   REFERENCES peca_produto(id_peca)  ON DELETE CASCADE  ON UPDATE CASCADE,
    FOREIGN KEY (id_status) REFERENCES status_peca(id_status) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 6. ÍNDICES
CREATE INDEX idx_ajuste_id_item             ON ajuste(id_item);
CREATE INDEX idx_historico_peca_id_peca     ON historico_peca(id_peca);
CREATE INDEX idx_historico_peca_id_status   ON historico_peca(id_status);
CREATE INDEX idx_item_locacao_id_locacao    ON item_locacao(id_locacao);
CREATE INDEX idx_item_locacao_id_peca       ON item_locacao(id_peca);
CREATE INDEX idx_locacao_id_cliente         ON locacao(id_cliente);
CREATE INDEX idx_locacao_id_funcionario     ON locacao(id_funcionario);
CREATE INDEX idx_locacao_id_usuario         ON locacao(id_usuario);
CREATE INDEX idx_locacao_data_evento        ON locacao(data_evento);
CREATE INDEX idx_manutencao_id_peca         ON manutencao(id_peca);
CREATE INDEX idx_pagamento_id_locacao       ON pagamento(id_locacao);

-- ===================== PARTE 2 - DML =====================
-- =====================================================================
-- TRAJELOC - Script DML (dados de teste) - entrega final de BD (E2)
-- Rodar depois do PI_3_BD_Script_MYSQL_trajeloc.sql, em um banco vazio.
--
-- Os registros 1 a 3 de cada tabela são os da versão anterior (mesmos IDs,
-- logins e situações usadas nos casos de teste do sistema). Os demais
-- completam pelo menos 5 registros por tabela, com dados da operação da loja.
-- =====================================================================
USE trajeloc;

-- 1. USUÁRIOS (1 administrador, 4 funcionários, 5 clientes com acesso)
INSERT INTO usuario (nome, email, senha, perfil_acesso) VALUES
('Carlos Andrade',     'carlos.admin@trajeloc.com',   'admin123',  'ADMINISTRADOR'),
('Mariana Lima',       'mariana.func@trajeloc.com',   'func123',   'FUNCIONARIO'),
('Juliana Mendes',     'juliana.func@trajeloc.com',   'func123',   'FUNCIONARIO'),
('Gerson Nogueira',    'gerson.func@trajeloc.com',    'func123',   'FUNCIONARIO'),
('Roberto Alves',      'roberto.cliente@gmail.com',   'client123', 'CLIENTE'),
('Fernanda Costa',     'fernanda.cliente@gmail.com',  'client123', 'CLIENTE'),
('Lucas Santos',       'lucas.cliente@gmail.com',     'client123', 'CLIENTE'),
('Patrícia Rocha',     'patricia.func@trajeloc.com',  'func123',   'FUNCIONARIO'),
('Ana Beatriz Moura',  'anabeatriz.moura@gmail.com',  'client123', 'CLIENTE'),
('Rafael Teixeira',    'rafael.teixeira@outlook.com', 'client123', 'CLIENTE');

-- 2. STATUS DA PEÇA
INSERT INTO status_peca (descricao) VALUES
('Disponível'),
('Reservada'),
('Em ajuste'),
('Em lavanderia'),
('Em manutenção');

-- 3. ACERVO
INSERT INTO peca_produto (codigo_unico, descricao, tamanho, cor, material, preco, sexo) VALUES
('TRJ-001', 'Terno Slim Fit Completo',                    'M',  'Preto',          'Lã Fria',   250.00, 'Masculino'),
('TRJ-002', 'Vestido de Gala Sereia',                     'P',  'Vermelho',       'Seda',      380.00, 'Feminino'),
('TRJ-003', 'Smoking Tradicional com Gravata Borboleta',  'G',  'Azul Marinho',   'Poliéster', 300.00, 'Masculino'),
('TRJ-004', 'Vestido Longo Tomara que Caia',              'M',  'Azul Serenity',  'Cetim',     420.00, 'Feminino'),
('TRJ-005', 'Terno Risca de Giz',                         'G',  'Cinza Chumbo',   'Lã Fria',   280.00, 'Masculino'),
('TRJ-006', 'Vestido de Debutante com Saia Rodada',       'P',  'Rosa Bebê',      'Tule',      450.00, 'Feminino'),
('TRJ-007', 'Fraque Clássico',                            'GG', 'Preto',          'Casimira',  350.00, 'Masculino'),
('TRJ-008', 'Vestido de Madrinha Longo',                  'M',  'Verde Esmeralda','Crepe',     320.00, 'Feminino');

-- 4. CLIENTES (a última não tem login no sistema: id_usuario nulo)
INSERT INTO cliente (id_usuario, nome, cpf, telefone, endereco, rg, medidas, data_nascimento) VALUES
(5,    'Roberto Alves',     '111.222.333-44', '(19) 98765-4321', 'Rua das Flores, 123 - Indaiatuba',            '12.345.678-9', 'Tórax: 98, Cintura: 84, Calça: 42',       '1990-05-15'),
(6,    'Fernanda Costa',    '222.333.444-55', '(19) 97654-3210', 'Av. Presidente Vargas, 456 - Indaiatuba',     '23.456.789-0', 'Busto: 85, Cintura: 70, Quadril: 95',     '1995-08-20'),
(7,    'Lucas Santos',      '333.444.555-66', '(19) 96543-2109', 'Rua XV de Novembro, 789 - Campinas',          '34.567.890-1', 'Tórax: 102, Cintura: 88',                 '1988-12-10'),
(9,    'Ana Beatriz Moura', '444.111.222-33', '(19) 99812-3344', 'Rua Pedro Gonçalves, 210 - Indaiatuba',       '45.123.456-7', 'Busto: 80, Cintura: 62, Quadril: 88',     '2011-02-14'),
(10,   'Rafael Teixeira',   '555.222.333-44', '(19) 98123-7788', 'Av. Conceição, 1500 - Indaiatuba',            '56.234.567-8', 'Tórax: 108, Cintura: 96, Calça: 46',      '1983-09-03'),
(NULL, 'Camila Ferreira',   '666.333.444-55', '(11) 97452-9090', 'Rua Sete de Setembro, 88 - Salto',            '67.345.678-9', 'Busto: 88, Cintura: 68, Quadril: 96',     '1999-06-27');

-- 5. FUNCIONÁRIOS
INSERT INTO funcionario (id_usuario, nome, cpf, rg, telefone, ctps, dependente, sexo, salario, data_nascimento, estado_civil, ativo) VALUES
(2, 'Mariana Lima',    '444.555.666-77', '45.678.901-2', '(19) 95432-1098', '1234567/0001', 1, 'Feminino',  2800.00, '1992-03-25', 'Casada',   TRUE),
(3, 'Juliana Mendes',  '555.666.777-88', '56.789.012-3', '(19) 94321-0987', '2345678/0001', 0, 'Feminino',  2500.00, '1997-07-11', 'Solteira', TRUE),
(4, 'Gerson Nogueira', '666.777.888-99', '67.890.123-4', '(19) 93210-9876', '3456789/0001', 2, 'Masculino', 3100.00, '1985-01-30', 'Casado',   TRUE),
(8, 'Patrícia Rocha',  '777.888.999-00', '78.901.234-5', '(19) 92109-8765', '4567890/0001', 0, 'Feminino',  2400.00, '2001-10-18', 'Solteira', TRUE),
(1, 'Carlos Andrade',  '888.999.000-11', '89.012.345-6', '(19) 99001-2233', '5678901/0001', 2, 'Masculino', 4500.00, '1982-11-05', 'Casado',   TRUE);

-- 6. LOCAÇÕES (data_entrega = retirada da peça pelo cliente)
INSERT INTO locacao (id_cliente, id_usuario, id_funcionario, data_evento, data_entrega, data_devolucao, status, multa) VALUES
(1, 2, 1, '2026-11-10', '2026-11-09', '2026-11-12', 'CONCLUIDA', 0.00),
(2, 2, 1, '2026-10-01', '2026-09-30', '2026-10-03', 'CONCLUIDA', 0.00),
(3, 3, 2, '2026-12-05', '2026-12-04', NULL,         'RESERVADA', 0.00),
(4, 3, 2, '2026-12-12', '2026-12-11', '2026-12-14', 'RESERVADA', 0.00),
(5, 4, 3, '2026-11-28', '2026-11-27', '2026-11-30', 'RESERVADA', 0.00),
(2, 2, 1, '2026-12-19', '2026-12-18', '2026-12-21', 'RESERVADA', 0.00),
(6, 8, 4, '2026-10-17', '2026-10-16', '2026-10-19', 'CONCLUIDA', 40.00);

-- 7. ITENS DAS LOCAÇÕES (preço do aluguel no momento da reserva)
INSERT INTO item_locacao (id_locacao, id_peca, preco_aluguel) VALUES
(1, 1, 250.00),
(2, 2, 380.00),
(3, 3, 300.00),
(4, 6, 450.00),
(5, 5, 280.00),
(5, 7, 350.00),
(6, 4, 420.00),
(6, 8, 320.00),
(7, 2, 380.00);

-- 8. PAGAMENTOS (sinal de no mínimo 30% na reserva e saldo na retirada)
INSERT INTO pagamento (id_locacao, valor) VALUES
(1,  75.00), (1, 175.00),
(2, 114.00), (2, 266.00),
(3,  90.00),
(4, 135.00),
(5, 189.00),
(6, 222.00),
(7, 114.00), (7, 266.00), (7, 40.00);

-- 9. AJUSTES (feitos na prova, por item da locação)
INSERT INTO ajuste (id_item, descricao) VALUES
(1, 'Ajustar barra da calça em 2 cm'),
(2, 'Apertar a cintura do vestido em 1 cm'),
(3, 'Ajustar comprimento da manga do paletó'),
(4, 'Reduzir o busto em 1,5 cm e subir a alça'),
(7, 'Fazer bainha para salto de 10 cm'),
(8, 'Encurtar as alças em 2 cm');

-- 10. MANUTENÇÕES
INSERT INTO manutencao (id_peca, descricao, data_manutencao) VALUES
(1, 'Lavagem a seco e passadoria',                 '2026-10-05'),
(2, 'Troca do zíper invisível das costas',         '2026-09-15'),
(3, 'Remoção de mancha na lapela',                 '2026-08-20'),
(7, 'Costura da lapela descosturada',              '2026-11-03'),
(4, 'Reposição de pedrarias do busto',             '2026-11-06');

-- 11. HISTÓRICO DE STATUS DAS PEÇAS
INSERT INTO historico_peca (id_peca, id_status, data_inicio, data_fim) VALUES
(1, 1, '2026-01-05 09:00:00', NULL),
(2, 2, '2026-09-28 10:00:00', '2026-10-03 18:00:00'),
(2, 4, '2026-10-04 09:00:00', '2026-10-06 17:00:00'),
(3, 5, '2026-08-20 09:00:00', '2026-08-22 17:00:00'),
(3, 2, '2026-11-15 14:00:00', NULL),
(6, 3, '2026-11-18 10:00:00', NULL),
(7, 5, '2026-11-03 09:00:00', '2026-11-04 16:00:00'),
(4, 1, '2026-11-07 09:00:00', NULL);

-- ===================== PARTE 3 - CONSULTAS =====================
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
