use trajeloc;

select *From manutencao;

-- TABELAS 
-- Criamos 7 usuários no total (1 Admin, 3 Funcionários, 3 Clientes)
INSERT INTO usuario (nome, email, senha, perfil_acesso) VALUES
('Carlos Andrade', 'carlos.admin@trajeloc.com', 'admin123', 'ADMINISTRADOR'),
('Mariana Lima', 'mariana.func@trajeloc.com', 'func123', 'FUNCIONARIO'),
('Juliana Mendes', 'juliana.func@trajeloc.com', 'func123', 'FUNCIONARIO'),
('Gerson Nogueira', 'gerson.func@trajeloc.com', 'func123', 'FUNCIONARIO'),
('Roberto Alves', 'roberto.cliente@gmail.com', 'client123', 'CLIENTE'),
('Fernanda Costa', 'fernanda.cliente@gmail.com', 'client123', 'CLIENTE'),
('Lucas Santos', 'lucas.cliente@gmail.com', 'client123', 'CLIENTE');

INSERT INTO status_peca (descricao) VALUES
('Disponível'),
('Alugada'),
('Em Manutenção');

INSERT INTO peca_produto (codigo_unico, descricao, tamanho, cor, material, preco, sexo) VALUES
('TRJ-001', 'Terno Slim Fit Completo', 'M', 'Preto', 'Lã Fria', 250.00, 'Masculino'),
('TRJ-002', 'Vestido de Gala Sereia', 'P', 'Vermelho', 'Seda', 380.00, 'Feminino'),
('TRJ-003', 'Smoking Tradicional com Gravata Borboleta', 'G', 'Azul Marinho', 'Poliéster', 300.00, 'Masculino');

-- 2. SUBENTIDADES (Cada Funcionário e Admin apontando para seu próprio id_usuario único)
INSERT INTO cliente (id_usuario, nome, cpf, telefone, endereco, rg, medidas, data_nascimento) VALUES
(5, 'Roberto Alves', '111.222.333-44', '(19) 98765-4321', 'Rua das Flores, 123 - Indaiatuba', '12.345.678-9', 'Busto: 90, Cintura: 80, Quadril: 100', '1990-05-15 00:00:00'),
(6, 'Fernanda Costa', '222.333.444-55', '(19) 97654-3210', 'Av. Presidente Vargas, 456 - Indaiatuba', '23.456.789-0', 'Busto: 85, Cintura: 70, Quadril: 95', '1995-08-20 00:00:00'),
(7, 'Lucas Santos', '333.444.555-66', '(19) 96543-2109', 'Rua XV de Novembro, 789 - Campinas', '34.567.890-1', 'Tórax: 102, Cintura: 88', '1988-12-10 00:00:00');

INSERT INTO funcionario (id_usuario, nome, cpf, rg, telefone, ctps, dependente, sexo, salario, data_nascimento, estado_civil) VALUES
(2, 'Mariana Lima', '444.555.666-77', '45.678.901-2', '(19) 95432-1098', '1234567/0001', 1, 'Feminino', 2800.00, '1992-03-25 00:00:00', 'Casada'),
(3, 'Juliana Mendes', '555.666.777-88', '56.789.012-3', '(19) 94321-0987', '2345678/0001', 0, 'Feminino', 2500.00, '1997-07-11 00:00:00', 'Solteira'),
(4, 'Gerson Nogueira', '666.777.888-99', '67.890.123-4', '(19) 93210-9876', '3456789/0001', 2, 'Masculino', 3100.00, '1985-01-30 00:00:00', 'Casado');

INSERT INTO administrador (id_usuario, nome, cpf, rg, data_nascimento) VALUES
(1, 'Carlos Andrade', '777.888.999-00', '78.901.234-5', '1982-11-05 00:00:00');

-- 3. OPERAÇÕES DE NEGÓCIO
INSERT INTO locacao (id_cliente, id_usuario, id_funcionario, data_evento, data_entrega, data_devolucao, status, multa, preco_total) VALUES
(1, 5, 1, '2026-11-10 18:00:00', '2026-11-09 14:00:00', '2026-11-12 10:00:00', 'RESERVADA', 0.00, 250.00),
(2, 6, 1, '2026-10-01 19:00:00', '2026-09-30 15:00:00', '2026-10-03 11:00:00', 'CONCLUIDA', 0.00, 380.00),
(3, 7, 2, '2026-12-05 20:00:00', '2026-12-04 13:00:00', NULL, 'EM_ANDAMENTO', 0.00, 300.00);

INSERT INTO pagamento (id_locacao, valor) VALUES
(1, 250.00),
(2, 380.00),
(3, 150.00);

-- 4. LOGÍSTICA E MANUTENÇÃO
INSERT INTO item_locacao (id_locacao, id_peca, preco_aluguel) VALUES
(1, 1, 250.00),
(2, 2, 380.00),
(3, 3, 300.00);

INSERT INTO ajuste (id_item, descricao) VALUES
(1, 'Ajustar barra da calça em 2cm'),
(2, 'Apertar a cintura do vestido em 1cm'),
(3, 'Ajustar comprimento da manga do terno');

INSERT INTO manutencao (id_peca, descricao, data_manutencao) VALUES
(1, 'Lavagem a seco e passar a ferro', '2026-10-05 09:00:00'),
(2, 'Troca de zíper invisível das costas', '2026-09-15 14:30:00'),
(3, 'Higienização e remoção de mancha na lapela', '2026-08-20 11:00:00');

INSERT INTO historico_peca (id_peca, id_status, data_inicio, data_fim) VALUES
(1, 1, '2026-01-01 08:00:00', NULL),
(2, 2, '2026-10-01 00:00:00', '2026-10-03 00:00:00'),
(3, 3, '2026-08-20 00:00:00', '2026-08-22 00:00:00');


Select *from usuario
