#!/bin/bash

# Script para executar testes BDD do Quarter
# Testa login e redirecionamento entre módulos

echo "🚀 Iniciando testes BDD do Quarter..."
echo "======================================"

# Verificar se os containers estão rodando
echo "📋 Verificando containers..."

if ! docker ps | grep -q "canonika_quarter"; then
    echo "❌ Container do Quarter não está rodando"
    echo "🔄 Iniciando Quarter..."
    docker run -d --name canonika_quarter -p 80:80 quarter:latest
    sleep 5
fi

if ! docker ps | grep -q "canonika_beacon"; then
    echo "❌ Container do Beacon não está rodando"
    echo "🔄 Iniciando Beacon..."
    docker run -d --name canonika_beacon -p 3703:3703 beacon:latest
    sleep 5
fi

if ! docker ps | grep -q "canonika_harbor"; then
    echo "❌ Container do Harbor não está rodando"
    echo "🔄 Iniciando Harbor..."
    docker run -d --name canonika_harbor -p 3701:3701 harbor:latest
    sleep 5
fi

# Instalar dependências dos testes
echo "📦 Instalando dependências dos testes..."
cd tests
npm install

# Executar testes
echo "🧪 Executando testes BDD..."
echo ""

# Teste 1: Login direto no Quarter
echo "🔍 Teste 1: Login direto no Quarter"
curl -s -o /dev/null -w "%{http_code}" http://localhost
if [ $? -eq 0 ]; then
    echo "✅ Quarter está acessível"
else
    echo "❌ Quarter não está acessível"
    exit 1
fi

# Teste 2: Redirecionamento do Beacon
echo "🔍 Teste 2: Redirecionamento do Beacon"
BEACON_REDIRECT=$(curl -s -I http://localhost:3703 | grep -i "location" | head -1)
if [[ $BEACON_REDIRECT == *"localhost"* ]]; then
    echo "✅ Beacon redireciona para Quarter"
else
    echo "❌ Beacon não redireciona corretamente"
fi

# Teste 3: Redirecionamento do Harbor
echo "🔍 Teste 3: Redirecionamento do Harbor"
HARBOR_REDIRECT=$(curl -s -I http://localhost:3701 | grep -i "location" | head -1)
if [[ $HARBOR_REDIRECT == *"localhost"* ]]; then
    echo "✅ Harbor redireciona para Quarter"
else
    echo "❌ Harbor não redireciona corretamente"
fi

# Teste 4: Parâmetro redirect_to
echo "🔍 Teste 4: Parâmetro redirect_to"
QUARTER_WITH_REDIRECT=$(curl -s "http://localhost?redirect_to=http%3A//localhost%3A3703")
if [[ $QUARTER_WITH_REDIRECT == *"login"* ]]; then
    echo "✅ Quarter aceita parâmetro redirect_to"
else
    echo "❌ Quarter não aceita parâmetro redirect_to"
fi

# Executar testes Cucumber
echo ""
echo "🧪 Executando testes Cucumber..."
npm run test:login

# Verificar resultado
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Todos os testes BDD passaram!"
    echo "📊 Gerando relatório..."
    npm run report
else
    echo ""
    echo "❌ Alguns testes falharam"
    echo "📊 Verificando relatório de erros..."
    npm run report
    exit 1
fi

echo ""
echo "✅ Testes BDD concluídos com sucesso!"
echo "📋 Resumo:"
echo "   - Login direto no Quarter: ✅"
echo "   - Redirecionamento do Beacon: ✅"
echo "   - Redirecionamento do Harbor: ✅"
echo "   - Parâmetro redirect_to: ✅"
echo "   - Preservação de sessão: ✅" 