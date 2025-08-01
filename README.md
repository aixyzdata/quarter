# Quarter - Microserviço de Autenticação Canonika

## Descrição

O Quarter é o ponto de entrada centralizado do sistema Canonika, responsável pela autenticação e redirecionamento para outros microserviços.

## Funcionalidades

- **Login Centralizado**: Interface de autenticação unificada
- **Redirecionamento**: Após login, redireciona para o Harbor (dashboard principal)
- **Hot Reload**: Desenvolvimento com atualizações automáticas
- **Testes**: TDD (unit tests) e BDD (end-to-end tests)

## Tecnologias

- **Frontend**: Vue.js 3 + Vite
- **Backend**: FastAPI (Python)
- **Proxy**: Nginx
- **Testes**: Vitest (unit) + Cypress (e2e)
- **Containerização**: Docker

## Estrutura do Projeto

```
quarter/
├── api/                 # Backend FastAPI
│   ├── main.py         # API principal
│   └── requirements.txt # Dependências Python
├── web/                # Frontend Vue.js
│   ├── src/
│   │   └── App.vue     # Componente principal
│   ├── tests/          # Testes unitários
│   ├── cypress/        # Testes e2e
│   └── package.json    # Dependências Node.js
├── nginx/              # Configuração do proxy
│   └── nginx.conf
├── Dockerfile          # Container principal
└── README.md           # Esta documentação
```

## Portas

- **80**: Interface web (Nginx)
- **8000**: API FastAPI
- **5174**: Hot reload (desenvolvimento)

## Desenvolvimento

### Pré-requisitos

- Docker e Docker Compose
- Node.js 18+
- Python 3.9+

### Execução Local

```bash
# Instalar dependências
cd web && npm install

# Executar frontend (hot reload)
npm run dev

# Executar backend
cd ../api && python -m uvicorn main:app --reload --port 8000

# Executar testes
npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
```

### Execução com Docker

```bash
# Build e execução
docker-compose up quarter

# Apenas build
docker build -t quarter .
```

## Testes

### Unit Tests (TDD)

```bash
npm run test
npm run test:coverage
```

### End-to-End Tests (BDD)

```bash
npm run test:e2e
npm run test:e2e:open
```

## Deploy

O Quarter é configurado para rodar na porta 80 (padrão web) e integra-se com:

- **Harbor**: Dashboard principal (porta 3701)
- **Guardian**: Sistema de segurança (porta 3705)
- **Keycloak**: Identity Provider (porta 8080)

## Integração

O Quarter funciona como ponto de entrada do Canonika:

1. Usuário acessa `http://localhost`
2. Faz login com credenciais
3. É redirecionado para Harbor (`http://localhost:3701`)
4. Harbor pode fazer logout de volta para Quarter

## Configuração

### Variáveis de Ambiente

- `DEV_MODE`: Habilita hot reload (true/false)
- `DATABASE_URL`: URL do PostgreSQL
- `REDIS_URL`: URL do Redis
- `KEYCLOAK_URL`: URL do Keycloak
- `OPA_URL`: URL do OPA

## Status

✅ **Implementado**:
- Login centralizado
- Redirecionamento para Harbor
- Hot reload em desenvolvimento
- Testes unitários e e2e
- Containerização Docker
- Integração com stack completa

🔄 **Em Desenvolvimento**:
- Integração com Keycloak
- Autenticação OAuth/OIDC
- Logs de auditoria

📋 **Planejado**:
- MFA (Multi-Factor Authentication)
- SSO (Single Sign-On)
- Integração com Guardian
- Métricas e monitoramento 