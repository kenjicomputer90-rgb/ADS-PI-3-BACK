CREATE DATABASE IF NOT EXISTS trajeloc;
USE trajeloc;

-- TABELAS 
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil_acesso VARCHAR(50) NOT NULL
);

CREATE TABLE status_peca (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE peca_produto (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    codigo_unico VARCHAR(50) UNIQUE,
    descricao VARCHAR(150) NOT NULL,
    tamanho VARCHAR(10) NOT NULL,
    cor VARCHAR(30) NOT NULL,
    material VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL,
    sexo VARCHAR(20)
);

-- 3. SUBENTIDADES (ESPECIALIZAÇÕES DE USUÁRIO)
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNIQUE,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(150) NOT NULL,
    rg VARCHAR(20),
    medidas TEXT,
    data_nascimento DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    rg VARCHAR(20),
    telefone VARCHAR(20),
    ctps VARCHAR(20),
    dependente INT DEFAULT 0,
    sexo VARCHAR(20),
    salario DECIMAL(10,2),
    data_nascimento DATETIME,
    estado_civil VARCHAR(30),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE administrador (
    id_administrador INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    rg VARCHAR(20),
    data_nascimento DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. OPERAÇÕES DE NEGÓCIO
CREATE TABLE locacao (
    id_locacao INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_evento DATETIME NOT NULL,
    data_entrega DATETIME,
    data_devolucao DATETIME,
    status VARCHAR(30) NOT NULL DEFAULT 'RESERVADA',
    multa DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    preco_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_locacao INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. LOGÍSTICA E MANUTENÇÃO
CREATE TABLE item_locacao (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_locacao INT NOT NULL,
    id_peca INT NOT NULL,
    preco_aluguel DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES peca_produto(id_peca) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ajuste (
    id_ajuste INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT NOT NULL,
    descricao TEXT NOT NULL,
    FOREIGN KEY (id_item) REFERENCES item_locacao(id_item) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE manutencao (
    id_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    id_peca INT NOT NULL,
    descricao TEXT NOT NULL,
    data_manutencao DATETIME NOT NULL,
    FOREIGN KEY (id_peca) REFERENCES peca_produto(id_peca) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE historico_peca (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_peca INT NOT NULL,
    id_status INT NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    FOREIGN KEY (id_peca) REFERENCES peca_produto(id_peca) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_status) REFERENCES status_peca(id_status) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 6. ÍNDICES DE PERFORMANCE
CREATE INDEX idx_ajuste_id_item ON ajuste(id_item);
CREATE INDEX idx_historico_peca_id_peca ON historico_peca(id_peca);
CREATE INDEX idx_historico_peca_id_status ON historico_peca(id_status);
CREATE INDEX idx_item_locacao_id_locacao ON item_locacao(id_locacao);
CREATE INDEX idx_item_locacao_id_peca ON item_locacao(id_peca);
CREATE INDEX idx_locacao_id_cliente ON locacao(id_cliente);
CREATE INDEX idx_locacao_id_funcionario ON locacao(id_funcionario);
CREATE INDEX idx_locacao_id_usuario ON locacao(id_usuario);
CREATE INDEX idx_manutencao_id_peca ON manutencao(id_peca);
CREATE INDEX idx_pagamento_id_locacao ON pagamento(id_locacao);