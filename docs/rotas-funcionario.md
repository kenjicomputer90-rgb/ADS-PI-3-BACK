# Módulo Funcionário — Rotas da API

Base: `http://localhost:3000` · Prefixo: `/funcionarios`
Arquivos: `controller/FuncionarioController`, `service/FuncionarioService`, `repository/FuncionarioRepository`, `dto/FuncionarioRequest`, `dto/FuncionarioResponse`, `model/Funcionario`.

## Resumo

| Método | Rota | Função | Respostas |
|---|---|---|---|
| GET | `/funcionarios` | Listar funcionários | 200 |
| GET | `/funcionarios?nome={valor}` | Filtrar por parte do nome (ordem alfabética) | 200 |
| GET | `/funcionarios?ativo={true\|false}` | Filtrar por situação (combina com `nome`) | 200 |
| GET | `/funcionarios/{id}` | Buscar por ID | 200 / 404 |
| GET | `/funcionarios/cpf?valor={cpf}` | Buscar por CPF | 200 / 404 |
| POST | `/funcionarios` | Cadastrar | 201 / 400 / 404 / 409 |
| PUT | `/funcionarios/{id}` | Atualizar (ficha inteira) | 200 / 400 / 404 / 409 |
| PATCH | `/funcionarios/{id}/desativar` | Marcar como inativo | 200 / 404 |
| PATCH | `/funcionarios/{id}/ativar` | Marcar como ativo | 200 / 404 |
| DELETE | `/funcionarios/{id}` | Excluir | 204 / 404 / 409 |

## Corpo da requisição (POST e PUT) — `FuncionarioRequest`

| Campo | Tipo | Obrigatório | Regra |
|---|---|---|---|
| `idUsuario` | Integer | Sim | Deve existir em `usuario` e não estar vinculado a outro funcionário |
| `nome` | String | Sim | Até 100 caracteres |
| `cpf` | String | Sim | Formato `000.000.000-00`; único |
| `rg` | String | Não | Até 20 caracteres |
| `telefone` | String | Não | Até 20 caracteres |
| `ctps` | String | Não | Até 20 caracteres |
| `dependente` | Integer | Não | ≥ 0; se omitido, grava 0 |
| `sexo` | String | Não | Até 20 caracteres |
| `salario` | Decimal | Não | ≥ 0; até 8 dígitos inteiros e 2 decimais |
| `dataNascimento` | Date (`AAAA-MM-DD`) | Não | Deve estar no passado |
| `estadoCivil` | String | Não | Até 30 caracteres |

O campo `ativo` **não** vai no corpo: ele só muda pelas rotas `ativar`/`desativar`.

Exemplo:
```json
{
  "idUsuario": 8,
  "nome": "Paula Souza",
  "cpf": "123.456.789-00",
  "telefone": "(19) 99999-0000",
  "salario": 2500.00,
  "dataNascimento": "1998-05-20",
  "estadoCivil": "Solteira"
}
```

## Corpo da resposta — `FuncionarioResponse`

```json
{
  "idFuncionario": 4,
  "idUsuario": 8,
  "nome": "Paula Souza",
  "cpf": "123.456.789-00",
  "rg": null,
  "telefone": "(19) 99999-0000",
  "ctps": null,
  "dependente": 0,
  "sexo": null,
  "salario": 2500.00,
  "dataNascimento": "1998-05-20",
  "estadoCivil": "Solteira",
  "ativo": true
}
```
Do usuário vinculado, só sai o `idUsuario` (a senha nunca é devolvida).

## Formato dos erros

| Código | Quando | Exemplo de corpo |
|---|---|---|
| 400 | Campo inválido (validação do `FuncionarioRequest`) | `{"nome": "O nome é obrigatório", "cpf": "O CPF deve estar no formato 000.000.000-00"}` |
| 404 | Funcionário ou usuário não encontrado | `{"erro": "Funcionário não encontrado: 99"}` |
| 409 | CPF já cadastrado, usuário já vinculado, ou exclusão bloqueada por locações | `{"erro": "Já existe um funcionário com esse CPF"}` |

## Detalhe de cada rota

### 2.1 Listar funcionários
| Item | Detalhes |
|---|---|
| Método e rota | `GET /funcionarios` |
| Função | Listar funcionários, com filtros opcionais |
| Parâmetros | Query: `nome` (String, opcional, busca por parte do nome, sem diferenciar maiúsculas); `ativo` (Boolean, opcional: `true` só ativos, `false` só inativos) |
| Corpo | Nenhum |
| Retorno | 200 com lista de `FuncionarioResponse` (em ordem alfabética quando há filtro por nome) |

### 2.2 Buscar funcionário por ID
| Item | Detalhes |
|---|---|
| Método e rota | `GET /funcionarios/{id}` |
| Função | Buscar pelo identificador |
| Parâmetros | Path: `id` (Integer) |
| Corpo | Nenhum |
| Retorno | 200 com `FuncionarioResponse`; 404 se não existir |

### 2.3 Buscar funcionário por CPF
| Item | Detalhes |
|---|---|
| Método e rota | `GET /funcionarios/cpf?valor={cpf}` |
| Função | Buscar pelo CPF exato |
| Parâmetros | Query: `valor` (String, ex.: `555.666.777-88`) |
| Corpo | Nenhum |
| Retorno | 200 com `FuncionarioResponse`; 404 se não existir |

### 2.4 Cadastrar funcionário
| Item | Detalhes |
|---|---|
| Método e rota | `POST /funcionarios` |
| Função | Cadastrar. Todo funcionário novo começa com `ativo = true` |
| Parâmetros | Corpo JSON (`FuncionarioRequest`) |
| Regras | CPF único; usuário deve existir e estar livre; `dependente` omitido vira 0 |
| Retorno | 201 com `FuncionarioResponse`; 400 validação; 404 usuário inexistente; 409 CPF ou usuário já usados |

### 2.5 Atualizar funcionário
| Item | Detalhes |
|---|---|
| Método e rota | `PUT /funcionarios/{id}` |
| Função | Atualizar a ficha inteira (todos os campos são reenviados) |
| Parâmetros | Path: `id` (Integer); corpo JSON (`FuncionarioRequest`) |
| Regras | O próprio CPF e o próprio usuário podem ser mantidos; conflito só com **outro** funcionário. Não altera `ativo` |
| Retorno | 200 com `FuncionarioResponse`; 400 / 404 / 409 |

### 2.6 Desativar funcionário
| Item | Detalhes |
|---|---|
| Método e rota | `PATCH /funcionarios/{id}/desativar` |
| Função | Marcar como inativo (saiu da loja). A ficha e o histórico de locações são preservados |
| Parâmetros | Path: `id` (Integer) |
| Corpo | Nenhum |
| Retorno | 200 com `FuncionarioResponse` (`ativo: false`); 404 se não existir. Repetir a chamada não gera erro |

### 2.7 Ativar funcionário
| Item | Detalhes |
|---|---|
| Método e rota | `PATCH /funcionarios/{id}/ativar` |
| Função | Marcar como ativo novamente |
| Parâmetros | Path: `id` (Integer) |
| Corpo | Nenhum |
| Retorno | 200 com `FuncionarioResponse` (`ativo: true`); 404 se não existir |

### 2.8 Excluir funcionário
| Item | Detalhes |
|---|---|
| Método e rota | `DELETE /funcionarios/{id}` |
| Função | Excluir definitivamente |
| Parâmetros | Path: `id` (Integer) |
| Corpo | Nenhum |
| Retorno | 204; 404 se não existir; 409 se o funcionário tiver locações (o banco protege o histórico — use `desativar`) |

## Testes automatizados

Coleção Bruno em `Trajeloc-API/Funcionario` (17 requisições, 18 testes). Com a aplicação rodando:
```bash
cd Trajeloc-API && bru run Funcionario --env local
```
Os testes criam um usuário e um funcionário de teste e os removem ao final, então podem ser executados quantas vezes for preciso.