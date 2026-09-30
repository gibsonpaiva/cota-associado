#!/bin/bash
# Script para iniciar o servidor local e abrir a Landing Page da Valoriza Car no navegador

# Garante que o script rode a partir da pasta do projeto
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

PORT=8080
URL="http://localhost:$PORT"

echo "=================================================="
echo "  🚗 Valoriza Car - Simulador de Proteção Veicular"
echo "=================================================="

# Verifica se já existe um servidor rodando na porta
if lsof -i :$PORT >/dev/null 2>&1; then
  echo "✓ Servidor já está ativo em $URL"
  echo "→ Abrindo o navegador..."
  open "$URL"
  exit 0
fi

# Caso o Python 3 esteja disponível, sobe um servidor HTTP local limpo
if command -v python3 >/dev/null 2>&1; then
  echo "→ Iniciando servidor local em $URL ..."
  echo "→ Abrindo o seu navegador padrão..."
  echo "  (Pressione Ctrl+C nesta janela quando quiser encerrar o servidor)"
  echo ""
  # Abre o navegador após 1 segundo
  (sleep 1 && open "$URL") &
  python3 -m http.server "$PORT" --bind 127.0.0.1
else
  # Fallback direto para abrir o arquivo HTML caso não tenha Python
  echo "→ Abrindo index.html diretamente no navegador..."
  open "$DIR/index.html"
fi
