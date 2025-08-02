# Testes BDD do Quarter

## 📋 Visão Geral

Este diretório contém os testes BDD (Behavior-Driven Development) para o Quarter, o sistema de login centralizado do Canonika.

## 🎯 Objetivos dos Testes

- **Validar login** direto no Quarter
- **Testar redirecionamento** a partir de outros módulos (Beacon, Skipper, Harbor)
- **Verificar preservação** de sessão entre módulos
- **Garantir funcionamento** do parâmetro `redirect_to`
- **Testar logout** global e limpeza de sessão

## 🏗️ Estrutura dos Testes

```
tests/
├── features/
│   └── login_redirect.feature    # Cenários de teste em Gherkin
├── steps/
│   └── login_steps.js            # Implementação dos steps
├── cucumber.js                   # Configuração do Cucumber
├── package.json                  # Dependências dos testes
└── README.md                     # Esta documentação
```

## 🚀 Como Executar

### Pré-requisitos

1. **Containers rodando:**
   ```bash
   # Quarter
   docker run -d --name canonika_quarter -p 80:80 quarter:latest
   
   # Beacon
   docker run -d --name canonika_beacon -p 3703:3703 beacon:latest
   
   # Harbor
   docker run -d --name canonika_harbor -p 3701:3701 harbor:latest
   ```

2. **Dependências instaladas:**
   ```bash
   cd tests
   npm install
   ```

### Execução dos Testes

#### Script Automatizado
```bash
./run-bdd-tests.sh
```

#### Testes Individuais
```bash
# Todos os testes
npm test

# Apenas testes de login
npm run test:login

# Testes em modo watch
npm run test:watch

# Testes em paralelo
npm run test:parallel
```

## 📊 Cenários de Teste

### 1. Login Direto no Quarter
- **Objetivo:** Validar login direto no Quarter
- **Fluxo:** Preencher credenciais → Clicar ENTRAR → Redirecionar para Harbor
- **Validação:** Sessão preservada, URL correta

### 2. Login a partir do Beacon
- **Objetivo:** Testar redirecionamento do Beacon para Quarter
- **Fluxo:** Acessar Beacon → Redirecionar para Quarter → Login → Voltar para Beacon
- **Validação:** URL com redirect_to, redirecionamento correto

### 3. Login a partir do Skipper
- **Objetivo:** Testar redirecionamento do Skipper para Quarter
- **Fluxo:** Acessar Skipper → Redirecionar para Quarter → Login → Voltar para Skipper
- **Validação:** URL com redirect_to, redirecionamento correto

### 4. Login a partir do Harbor
- **Objetivo:** Testar redirecionamento do Harbor para Quarter
- **Fluxo:** Acessar Harbor → Redirecionar para Quarter → Login → Voltar para Harbor
- **Validação:** URL com redirect_to, redirecionamento correto

### 5. Preservação de Sessão
- **Objetivo:** Verificar que a sessão é preservada entre módulos
- **Fluxo:** Login no Quarter → Acessar outros módulos
- **Validação:** Sem necessidade de novo login

### 6. Logout Global
- **Objetivo:** Testar logout e limpeza de sessão
- **Fluxo:** Logout em qualquer módulo → Redirecionar para Quarter
- **Validação:** Sessão limpa, não conseguir acessar módulos

### 7. Credenciais Inválidas
- **Objetivo:** Testar tratamento de credenciais incorretas
- **Fluxo:** Preencher credenciais inválidas → Clicar ENTRAR
- **Validação:** Mensagem de erro, permanecer na página

### 8. URL de redirect_to Inválida
- **Objetivo:** Testar fallback para URLs inválidas
- **Fluxo:** Login com redirect_to inválido → Redirecionar para Harbor
- **Validação:** Fallback para Harbor, sessão preservada

## 🔧 Configuração

### Variáveis de Ambiente
```bash
# URLs dos módulos (configuradas em login_steps.js)
QUARTER_URL=http://localhost
BEACON_URL=http://localhost:3703
SKIPPER_URL=http://localhost:3702
HARBOR_URL=http://localhost:3701
```

### Credenciais de Teste
```javascript
// Credenciais válidas
email: 'admin@canonika.io'
password: 'admin123'

// Credenciais inválidas
email: 'usuario@invalido.com'
password: 'senhaerrada'
```

## 📈 Relatórios

Os testes geram relatórios em HTML:
- **Localização:** `cucumber-report.html`
- **Comando:** `npm run report`
- **Conteúdo:** Cenários executados, resultados, screenshots

## 🐛 Troubleshooting

### Problemas Comuns

1. **Container não acessível:**
   ```bash
   # Verificar se está rodando
   docker ps | grep canonika
   
   # Reiniciar se necessário
   docker restart canonika_quarter
   ```

2. **Testes falhando por timeout:**
   ```bash
   # Aumentar timeout no cucumber.js
   timeout: 30000
   ```

3. **Puppeteer não consegue conectar:**
   ```bash
   # Verificar se as portas estão abertas
   netstat -an | grep :80
   netstat -an | grep :3703
   ```

### Logs de Debug

```bash
# Executar com logs detalhados
DEBUG=* npm run test:login

# Ver logs dos containers
docker logs canonika_quarter
docker logs canonika_beacon
docker logs canonika_harbor
```

## 🔄 Integração Contínua

### GitHub Actions
```yaml
name: Quarter BDD Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Start containers
        run: |
          docker run -d --name quarter -p 80:80 quarter:latest
          docker run -d --name beacon -p 3703:3703 beacon:latest
          docker run -d --name harbor -p 3701:3701 harbor:latest
      - name: Run BDD tests
        run: |
          cd quarter/tests
          npm install
          npm test
```

## 📝 Contribuição

Para adicionar novos cenários:

1. **Adicionar feature** em `features/`
2. **Implementar steps** em `steps/`
3. **Executar testes** para validar
4. **Atualizar documentação**

## 📚 Referências

- [Cucumber.js](https://cucumber.io/docs/cucumber/)
- [Puppeteer](https://pptr.dev/)
- [Chai Assertions](https://www.chaijs.com/)
- [BDD Best Practices](https://cucumber.io/docs/bdd/) 