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
