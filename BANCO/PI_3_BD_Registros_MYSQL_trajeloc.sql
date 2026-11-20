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
