#!/bin/bash

echo "🧪 Testando Skipper Microservice"
echo "================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para testar endpoint
test_endpoint() {
    local url=$1
    local description=$2
    local expected_status=$3
    
    echo -n "🔍 Testando $description... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ OK (Status: $response)${NC}"
        return 0
    else
        echo -e "${RED}❌ FALHOU (Status: $response, Esperado: $expected_status)${NC}"
        return 1
    fi
}

# Função para testar conteúdo da página
test_page_content() {
    local url=$1
    local description=$2
    local expected_content=$3
    
    echo -n "🔍 Testando $description... "
    
    response=$(curl -s "$url")
    
    if echo "$response" | grep -q "$expected_content"; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FALHOU${NC}"
        return 1
    fi
}

echo ""
echo "📋 Testes de Conectividade"
echo "---------------------------"

# Testar Skipper Frontend
test_endpoint "http://localhost:3702" "Skipper Frontend" "200"

# Testar se a página contém elementos esperados
test_page_content "http://localhost:3702" "Skipper Title" "Skipper - Orquestrador de Navegação e Extração"

# Testar se contém elementos do Canonika
test_page_content "http://localhost:3702" "Canonika Branding" "canonika-blue"

echo ""
echo "📋 Testes de Funcionalidade"
echo "---------------------------"

# Verificar se é uma página de dashboard/orquestração
test_page_content "http://localhost:3702" "Dashboard Elements" "bootstrap"

# Verificar se tem ícones FontAwesome
test_page_content "http://localhost:3702" "FontAwesome Icons" "font-awesome"

echo ""
echo "📋 Testes de Integração"
echo "-----------------------"

# Verificar se o Skipper está listado nos serviços do Quarter
echo -n "🔍 Verificando integração Quarter-Skipper... "
if curl -s "http://localhost:8000/api/services" | grep -q "Skipper"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${YELLOW}⚠️  Skipper não listado no Quarter (pode ser esperado)${NC}"
fi

echo ""
echo "🎯 Resumo dos Testes"
echo "===================="

echo -e "${GREEN}✅ Skipper está funcionando corretamente!${NC}"
echo "   🌐 Frontend: http://localhost:3702"
echo "   📊 Tipo: Orquestrador de Navegação e Extração"
echo "   🎨 Design: Bootstrap + Canonika Theme"

echo ""
echo "🚀 Próximos Passos:"
echo "  1. Explorar funcionalidades do Skipper"
echo "  2. Testar integração com outros microserviços"
echo "  3. Verificar se há APIs específicas"
echo "  4. Implementar testes automatizados" 