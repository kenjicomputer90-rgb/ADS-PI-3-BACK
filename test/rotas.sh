#!/bin/bash
BASE=http://localhost:8080
H="Content-Type: application/json"

# extrai o primeiro campo que comece com "id" (idUsuario, idCliente, id...)
get_id() { grep -o '"id[A-Za-z]*":[0-9]*' | head -1 | grep -o '[0-9]*$'; }
code()   { curl -s -o /dev/null -w "%{http_code}" "$@"; }
check()  { echo "  $1 -> HTTP $2 (esperado $3)"; }

# crud <nome> <rota> <json_criar> <json_atualizar>  (preenche a variável ID)
crud() {
  local nome=$1 rota=$2 criar=$3 atualizar=$4
  echo "=== $nome ($rota) ==="
  local resp=$(curl -s -w "\n%{http_code}" -X POST $BASE$rota -H "$H" -d "$criar")
  local status=$(echo "$resp" | tail -1)
  ID=$(echo "$resp" | head -n -1 | get_id)
  check "POST" $status "200/201"
  check "GET lista" $(code $BASE$rota) 200
  check "GET id=$ID" $(code $BASE$rota/$ID) 200
  if [ -n "$atualizar" ]; then
    check "PUT id=$ID" $(code -X PUT $BASE$rota/$ID -H "$H" -d "$atualizar") 200
  fi
}

apagar() { check "DELETE $1/$2" $(code -X DELETE $BASE$1/$2) "200/204"
           check "GET apagado" $(code $BASE$1/$2) "404"; }

# ---------- cadastros ----------
crud "Usuario" /usuarios \
 '{"nome":"Admin","email":"admin@teste.com","senha":"123456","perfilAcesso":"ADMIN"}' \
 '{"nome":"Admin 2","email":"admin@teste.com","senha":"123456","perfilAcesso":"ADMIN"}'
UID_=$ID

crud "Cliente" /clientes \
 '{"nome":"Cliente Teste","cpf":"111.111.111-11","telefone":"19999999999","endereco":"Rua A, 1"}' \
 '{"nome":"Cliente Editado","cpf":"111.111.111-11","telefone":"19999999999","endereco":"Rua B, 2"}'
CID=$ID

crud "Funcionario" /funcionarios \
 "{\"idUsuario\":$UID_,\"nome\":\"Func Teste\",\"cpf\":\"222.222.222-22\"}" \
 "{\"idUsuario\":$UID_,\"nome\":\"Func Editado\",\"cpf\":\"222.222.222-22\"}"
FID=$ID

crud "Produto 1" /produtos \
 '{"codigoUnico":"P001","descricao":"Terno","tamanho":"M","cor":"Preto","preco":150.00}' \
 '{"codigoUnico":"P001","descricao":"Terno Slim","tamanho":"M","cor":"Preto","preco":160.00}'
P1=$ID

crud "Produto 2" /produtos \
 '{"codigoUnico":"P002","descricao":"Gravata","tamanho":"U","cor":"Azul","preco":30.00}' ""
P2=$ID

# ---------- locação ----------
echo "=== Locacao (/locacoes) ==="
LOC="{\"idCliente\":$CID,\"idUsuario\":$UID_,\"idFuncionario\":$FID,\"dataEvento\":\"2026-11-20\",\"dataDevolucao\":\"2026-11-23\",\"idsPecas\":[$P1,$P2]}"
resp=$(curl -s -w "\n%{http_code}" -X POST $BASE/locacoes -H "$H" -d "$LOC")
LID=$(echo "$resp" | head -n -1 | get_id)
check "POST" $(echo "$resp" | tail -1) 201
check "GET lista" $(code $BASE/locacoes) 200
check "GET id=$LID" $(code $BASE/locacoes/$LID) 200
check "POST conflito" $(code -X POST $BASE/locacoes -H "$H" -d "$LOC") 409
check "POST sem peças" $(code -X POST $BASE/locacoes -H "$H" -d "{\"idCliente\":$CID,\"idUsuario\":$UID_,\"idFuncionario\":$FID,\"dataEvento\":\"2026-12-01\",\"idsPecas\":[]}") 400
check "POST cliente inexistente" $(code -X POST $BASE/locacoes -H "$H" -d "{\"idCliente\":999999,\"idUsuario\":$UID_,\"idFuncionario\":$FID,\"dataEvento\":\"2026-12-01\",\"idsPecas\":[$P1]}") 404
apagar /locacoes $LID

# ---------- limpeza (ordem inversa das dependências) ----------
echo "=== Limpeza ==="
apagar /produtos $P2
apagar /produtos $P1
apagar /funcionarios $FID
apagar /clientes $CID
apagar /usuarios $UID_