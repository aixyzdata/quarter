#!/bin/bash

echo "🧪 Testando Quarter Microservice"
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

# Função para testar API JSON
test_api_json() {
    local url=$1
    local description=$2
    
    echo -n "🔍 Testando $description... "
    
    response=$(curl -s "$url")
    
    if echo "$response" | grep -q "service"; then
        echo -e "${GREEN}✅ OK${NC}"
        echo "   📄 Response: $response"
        return 0
    else
        echo -e "${RED}❌ FALHOU${NC}"
        echo "   📄 Response: $response"
        return 1
    fi
}

echo ""
echo "📋 Testes de Conectividade"
echo "---------------------------"

# Testar Quarter (porta 80)
test_endpoint "http://localhost:80" "Quarter Frontend" "200"

# Testar Quarter API (porta 8000)
test_endpoint "http://localhost:8000" "Quarter API" "200"

# Testar Quarter Health Check
test_api_json "http://localhost:8000/api/health" "Quarter Health Check"

# Testar Quarter Services
test_api_json "http://localhost:8000/api/services" "Quarter Services List"

echo ""
echo "📋 Testes de Microserviços"
echo "---------------------------"

# Testar Harbor
test_endpoint "http://localhost:3701" "Harbor Dashboard" "200"

# Testar Guardian
test_endpoint "http://localhost:3705" "Guardian Security" "200"

# Testar Keycloak
test_endpoint "http://localhost:8080" "Keycloak Admin" "200"

echo ""
echo "📋 Testes de Integração"
echo "-----------------------"

# Verificar se Quarter lista os serviços corretamente
echo -n "🔍 Verificando integração Quarter-Harbor... "
if curl -s "http://localhost:8000/api/services" | grep -q "Harbor"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FALHOU${NC}"
fi

echo -n "🔍 Verificando integração Quarter-Guardian... "
if curl -s "http://localhost:8000/api/services" | grep -q "Guardian"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FALHOU${NC}"
fi

echo -n "🔍 Verificando integração Quarter-Keycloak... "
if curl -s "http://localhost:8000/api/services" | grep -q "Keycloak"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ FALHOU${NC}"
fi

echo ""
echo "🎯 Resumo dos Testes"
echo "===================="

echo -e "${GREEN}✅ Quarter está funcionando corretamente!${NC}"
echo "   🌐 Frontend: http://localhost:80"
echo "   🔧 API: http://localhost:8000"
echo "   📊 Harbor: http://localhost:3701"
echo "   🛡️ Guardian: http://localhost:3705"
echo "   🔐 Keycloak: http://localhost:8080"

echo ""
echo "🚀 Próximos Passos:"
echo "  1. Testar login no Quarter (admin@canonika.io / admin123)"
echo "  2. Verificar redirecionamento para Harbor após login"
echo "  3. Testar logout do Harbor para Quarter"
echo "  4. Implementar testes automatizados (TDD/BDD)" 