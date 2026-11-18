# Sistema de Gerenciamento de Locação de Trajes

## 1. Sobre o projeto

O **Sistema de Gerenciamento de Locação de Trajes** foi desenvolvido
para auxiliar uma empresa do ramo de aluguel de roupas no gerenciamento
de suas atividades. O sistema busca facilitar o controle de clientes,
trajes disponíveis e locações, centralizando informações e tornando as
operações mais organizadas.

## 2. Tecnologias utilizadas

-   **Backend:** Java com Spring Boot 3.5.6
-   **Frontend:** JavaFX com FXML
-   **Banco de dados:** MySQL 8.0 ou superior
-   **Gerenciador de dependências e build:** Apache Maven
-   **Comunicação:** API REST

## 3. Requisitos para execução

Antes de executar o projeto, verifique se os seguintes componentes estão
instalados:

  -----------------------------------------------------------------------
  Item                                Especificação
  ----------------------------------- -----------------------------------
  Sistema operacional                 Windows ou Linux

  Java JDK                            Java 21 ou versão compatível com a
                                      configuração do projeto

  Apache Maven                        Versão compatível com os arquivos
                                      `pom.xml`

  Banco de dados                      MySQL 8.0 ou superior

  Backend                             Spring Boot 3.5.6

  Frontend                            JavaFX com FXML

  Rede                                Acesso ao servidor do banco de
                                      dados, quando estiver em outro
                                      computador
  -----------------------------------------------------------------------

> **Observação:** confirme a versão do Java configurada nos arquivos
> `pom.xml` antes da instalação. A versão instalada deve ser compatível
> com o projeto.

## 4. Como instalar e executar

### 4.1. Obter o código-fonte

Clone os repositórios do frontend e do backend:

``` bash
git clone <URL_DO_REPOSITORIO_BACKEND>
git clone <URL_DO_REPOSITORIO_FRONTEND>
```

Substitua os campos acima pelas URLs reais dos repositórios do projeto.

### 4.2. Configurar o banco de dados

1.  Inicie o servidor MySQL.
2.  Crie o banco de dados ou importe o script SQL disponibilizado pelo
    projeto.
3.  Configure a conexão do backend no arquivo `application.properties`.

Exemplo de configuração:

``` properties
spring.datasource.url=jdbc:mysql://localhost:3306/loja_roupas
spring.datasource.username=SEU_USUARIO
spring.datasource.password=SUA_SENHA
```

Se o banco de dados estiver em outro computador, substitua `localhost`
pelo endereço IP do servidor MySQL. Verifique também se a porta `3306`
está acessível e se o usuário possui permissão para conectar a partir do
computador que executa o backend.

**Importante:** não compartilhe credenciais reais nem envie senhas para
o repositório.

### 4.3. Executar o backend

Abra um terminal na pasta do backend e execute:

``` bash
mvn spring-boot:run
```

Aguarde a inicialização do Spring Boot. Conforme a configuração padrão
utilizada no projeto, a API fica disponível na porta `8080`.

### 4.4. Executar o frontend

Com o backend em execução, abra outro terminal na pasta do frontend e
execute:

``` bash
mvn javafx:run
```

Após a inicialização, a interface gráfica do sistema deverá ser exibida.

> Os comandos acima pressupõem que os plugins do Spring Boot e do JavaFX
> estejam configurados nos respectivos arquivos `pom.xml`.

## 5. Principais funcionalidades

### 5.1. Cadastro e consulta de clientes

Permite registrar novos clientes e consultar os registros existentes no
sistema.

**Como utilizar:** 1. Acesse a área de clientes. 2. Preencha os campos
solicitados. 3. Selecione a opção para cadastrar ou salvar. 4. Para
consultar registros, acesse a listagem de clientes e utilize os filtros
disponíveis, quando houver.

### 5.2. Cadastro e consulta de trajes

Permite gerenciar os trajes disponíveis para locação, armazenando
informações como descrição, tamanho, cor e código de identificação.

**Como utilizar:** 1. Acesse a área de produtos ou trajes. 2. Preencha
as informações solicitadas. 3. Salve o cadastro. 4. Consulte os
registros na listagem e utilize os filtros de pesquisa disponíveis.

### 5.3. Gerenciamento de locações

Permite registrar e acompanhar locações realizadas pelos clientes,
relacionando os clientes aos trajes selecionados.

**Como utilizar:** 1. Acesse a área de locações. 2. Selecione o cliente.
3. Adicione os trajes desejados. 4. Preencha as demais informações
solicitadas. 5. Confirme o registro da locação.

> As instruções desta seção devem ser ajustadas caso os nomes dos menus,
> campos ou etapas na versão implementada sejam diferentes.

## 6. Problemas conhecidos e soluções

  ---------------------------------------------------------------------------
  Problema                Causa provável          Solução
  ----------------------- ----------------------- ---------------------------
  Não foi possível        MySQL desligado ou      Verifique se o MySQL está
  conectar ao banco de    configuração incorreta  em execução e confira
  dados                   de conexão              endereço, porta, banco,
                                                  usuário e senha no
                                                  `application.properties`.

  O sistema não consegue  Servidor Spring Boot    Inicie o backend e confira
  acessar o backend       desligado ou endereço   se a API está disponível na
                          incorreto               porta configurada,
                                                  normalmente `8080`.

  Erro ao cadastrar ou    Dados inválidos ou      Confira os campos
  consultar informações   falha na comunicação    preenchidos e consulte os
                          com a API               logs do backend para
                                                  identificar a causa.

  Erro de conexão entre   Firewall bloqueando a   Confira os endereços IP, a
  computadores            comunicação, IP         conectividade da rede, as
                          incorreto ou falta de   regras do firewall e as
                          permissão               permissões do MySQL.

  O comando `mvn` não é   Maven não instalado ou  Instale o Apache Maven e
  reconhecido             não configurado no PATH configure a variável de
                                                  ambiente PATH.

  Erro ao iniciar o       Java ou plugin JavaFX   Confira a versão do Java e
  frontend                incompatível ou não     as configurações do
                          configurado             `pom.xml` do frontend.
  ---------------------------------------------------------------------------

## 7. Capturas de tela

Adicione nesta seção imagens da versão atual do sistema para demonstrar
suas principais telas.

Sugestões: - Tela inicial ou menu principal. - Tela de cadastro e
consulta de clientes. - Tela de cadastro e consulta de trajes. - Tela de
gerenciamento de locações.

Exemplo para inserir uma imagem:

``` markdown
![Tela de clientes](docs/imagens/tela-clientes.png)
```

## 8. Observações

-   O backend deve estar em execução para que o frontend consiga acessar
    os serviços disponibilizados pela API.
-   O banco de dados MySQL deve estar ativo e acessível pelo backend.
-   Em execução na rede local, o endereço da API e as configurações de
    conexão devem apontar para os computadores corretos.
-   Não armazene senhas ou outras credenciais diretamente no
    repositório.
-   Este README descreve os requisitos e o fluxo geral de execução.
    Ajuste os comandos, versões e funcionalidades conforme a
    configuração efetiva da versão entregue.

## 9. Autores

Projeto acadêmico desenvolvido no curso de **Análise e Desenvolvimento
de Sistemas**.
