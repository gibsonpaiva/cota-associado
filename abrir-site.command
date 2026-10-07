#!/bin/bash
# Script para iniciar o servidor local e abrir a Landing Page da Valoriza Car no navegador

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

PORT=8080
URL="http://localhost:$PORT"

echo "=================================================="
echo "  🚗 VALORIZA CAR - SISTEMA DE COTAÇÃO & ADMIN"
echo "=================================================="
echo "  • Simulador de Clientes: $URL/index.html"
echo "  • Login do Consultor:   $URL/login.html"
echo "  • Painel de Cotações:   $URL/admin.html"
echo "  • Usuário Teste:        teste@gmail.com / qwe123"
echo "=================================================="

# Verifica se já existe um servidor rodando na porta
if lsof -i :$PORT >/dev/null 2>&1; then
  echo "✓ Servidor já ativo em $URL"
  echo "→ Abrindo navegador..."
  open "$URL"
  exit 0
fi

if command -v python3 >/dev/null 2>&1; then
  echo "→ Iniciando servidor local em $URL ..."
  echo "→ Abrindo o navegador padrão..."
  echo "  (Pressione Ctrl+C para encerrar o servidor quando terminar)"
  echo ""
  (sleep 1 && open "$URL") &
  python3 -m http.server "$PORT" --bind 127.0.0.1
else
  echo "→ Abrindo index.html diretamente no navegador..."
  open "$DIR/index.html"
fi
