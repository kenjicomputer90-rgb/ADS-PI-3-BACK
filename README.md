# 🚀 ADS PI 3

FATEC ADS Projeto Integrador 3°Semestre

Repositório criado para compartilhar e colaborar no desenvolvimento do sistema de Locação de Trajes para o projeto integrador 3

## Como rodar o back

Requisitos: JDK 25, Maven e MySQL 8.4.

1. Crie o banco e os dados de exemplo, rodando como root, nesta ordem, os scripts da pasta `BANCO`:
   - `PI_3_BD_Script_MYSQL_trajeloc.sql` (estrutura)
   - `PI_3_BD_Registros_MYSQL_trajeloc.sql` (registros de exemplo)
   - `PI_3_BD_Usuario_local_trajeloc.sql` (usuário `trajeloc` que o back usa)

   No terminal: `mysql -u root -p --default-character-set=utf8mb4 < BANCO/<arquivo>.sql`

2. Rode o back: `mvn spring-boot:run`. A API sobe na porta 3000.

Para usar outro usuário ou senha do MySQL sem alterar o `application.properties`, defina antes as variáveis `SPRING_DATASOURCE_USERNAME` e `SPRING_DATASOURCE_PASSWORD`.

## Acesso pela rede local

O banco só precisa existir no computador que roda o back. Os outros computadores rodam apenas o front, apontando para `http://<IP do servidor>:3000` (veja o README do front). O MySQL não fica exposto na rede.
