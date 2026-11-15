-- Cria o usuário que o back usa para conectar no banco local (application.properties).
-- Rodar uma vez, como root, depois dos scripts de estrutura e de registros.
CREATE USER IF NOT EXISTS 'trajeloc'@'localhost' IDENTIFIED BY 'trajeloc';
GRANT ALL PRIVILEGES ON trajeloc.* TO 'trajeloc'@'localhost';
FLUSH PRIVILEGES;
