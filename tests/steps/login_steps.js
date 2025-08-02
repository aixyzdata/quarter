const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');
const puppeteer = require('puppeteer');

let browser, page;

// Configurações dos módulos
const MODULES = {
  quarter: 'http://localhost',
  beacon: 'http://localhost:3703',
  skipper: 'http://localhost:3702',
  harbor: 'http://localhost:3701',
  guardian: 'http://localhost:3705'
};

// Setup e Teardown
Before(async function() {
  browser = await puppeteer.launch({ 
    headless: false,
    slowMo: 100 
  });
  page = await browser.newPage();
});

After(async function() {
  await browser.close();
});

// Steps de Contexto
Given('que estou na página de login do Quarter', async function() {
  await page.goto(MODULES.quarter);
  await page.waitForSelector('.login-container');
});

Given('que não estou autenticado', async function() {
  // Limpar localStorage para garantir que não está autenticado
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });
});

Given('que estou acessando o Beacon sem autenticação', async function() {
  await page.goto(MODULES.beacon);
  // Aguardar redirecionamento para Quarter
  await page.waitForFunction(() => window.location.href.includes('localhost'));
});

Given('que estou acessando o Skipper sem autenticação', async function() {
  await page.goto(MODULES.skipper);
  // Aguardar redirecionamento para Quarter
  await page.waitForFunction(() => window.location.href.includes('localhost'));
});

Given('que estou acessando o Harbor sem autenticação', async function() {
  await page.goto(MODULES.harbor);
  // Aguardar redirecionamento para Quarter
  await page.waitForFunction(() => window.location.href.includes('localhost'));
});

Given('que estou logado no Quarter', async function() {
  await page.goto(MODULES.quarter);
  await page.waitForSelector('.login-container');
  
  // Fazer login
  await page.type('input[type="email"]', 'admin@canonika.io');
  await page.type('input[type="password"]', 'admin123');
  await page.click('.login-btn');
  
  // Aguardar redirecionamento
  await page.waitForNavigation();
});

Given('que estou logado em qualquer módulo', async function() {
  // Fazer login através do Quarter
  await page.goto(MODULES.quarter);
  await page.waitForSelector('.login-container');
  
  await page.type('input[type="email"]', 'admin@canonika.io');
  await page.type('input[type="password"]', 'admin123');
  await page.click('.login-btn');
  
  await page.waitForNavigation();
});

Given('que estou na página de login do Quarter com redirect_to inválido', async function() {
  await page.goto(`${MODULES.quarter}?redirect_to=http://site-malicioso.com`);
  await page.waitForSelector('.login-container');
});

// Steps de Ação
When('eu preencho o email com {string}', async function(email) {
  await page.type('input[type="email"]', email);
});

When('preencho a senha com {string}', async function(password) {
  await page.type('input[type="password"]', password);
});

When('clico no botão {string}', async function(buttonText) {
  await page.click(`button:contains("${buttonText}")`);
});

When('sou redirecionado para o Quarter com redirect_to', async function() {
  // Verificar se a URL contém redirect_to
  const url = await page.url();
  expect(url).to.include('redirect_to');
});

When('acesso o Beacon', async function() {
  await page.goto(MODULES.beacon);
});

When('acesso o Skipper', async function() {
  await page.goto(MODULES.skipper);
});

When('acesso o Harbor', async function() {
  await page.goto(MODULES.harbor);
});

When('faço logout', async function() {
  // Procurar botão de logout em qualquer módulo
  const logoutSelectors = [
    '.logout-btn',
    'button:contains("Sair")',
    'button:contains("Logout")'
  ];
  
  for (const selector of logoutSelectors) {
    try {
      await page.waitForSelector(selector, { timeout: 2000 });
      await page.click(selector);
      break;
    } catch (e) {
      continue;
    }
  }
});

When('preencho as credenciais corretas', async function() {
  await page.type('input[type="email"]', 'admin@canonika.io');
  await page.type('input[type="password"]', 'admin123');
});

// Steps de Verificação
Then('devo ser redirecionado para o Harbor', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost:3701');
});

Then('minha sessão deve ser preservada', async function() {
  const authState = await page.evaluate(() => {
    return localStorage.getItem('canonika_authenticated');
  });
  expect(authState).to.equal('true');
});

Then('devo ser redirecionado de volta para o Beacon', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost:3703');
});

Then('devo ver a interface do Beacon', async function() {
  await page.waitForSelector('.canonika-app');
  const beaconContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(beaconContent).to.be.true;
});

Then('devo ser redirecionado de volta para o Skipper', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost:3702');
});

Then('devo ver a interface do Skipper', async function() {
  await page.waitForSelector('.canonika-app');
  const skipperContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(skipperContent).to.be.true;
});

Then('devo ser redirecionado de volta para o Harbor', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost:3701');
});

Then('devo ver a interface do Harbor', async function() {
  await page.waitForSelector('.canonika-app');
  const harborContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(harborContent).to.be.true;
});

Then('devo ver a interface do Beacon sem precisar fazer login novamente', async function() {
  await page.waitForSelector('.canonika-app');
  const beaconContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(beaconContent).to.be.true;
  
  // Verificar se não há formulário de login
  const loginForm = await page.evaluate(() => {
    return document.querySelector('.login-container') === null;
  });
  expect(loginForm).to.be.true;
});

Then('devo ver a interface do Skipper sem precisar fazer login novamente', async function() {
  await page.waitForSelector('.canonika-app');
  const skipperContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(skipperContent).to.be.true;
  
  const loginForm = await page.evaluate(() => {
    return document.querySelector('.login-container') === null;
  });
  expect(loginForm).to.be.true;
});

Then('devo ver a interface do Harbor sem precisar fazer login novamente', async function() {
  await page.waitForSelector('.canonika-app');
  const harborContent = await page.evaluate(() => {
    return document.querySelector('.canonika-app') !== null;
  });
  expect(harborContent).to.be.true;
  
  const loginForm = await page.evaluate(() => {
    return document.querySelector('.login-container') === null;
  });
  expect(loginForm).to.be.true;
});

Then('devo ser redirecionado para o Quarter', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost');
  expect(currentUrl).to.not.include('localhost:3701');
  expect(currentUrl).to.not.include('localhost:3702');
  expect(currentUrl).to.not.include('localhost:3703');
});

Then('minha sessão deve ser limpa', async function() {
  const authState = await page.evaluate(() => {
    return localStorage.getItem('canonika_authenticated');
  });
  expect(authState).to.be.null;
});

Then('não devo conseguir acessar outros módulos sem fazer login novamente', async function() {
  // Tentar acessar Beacon
  await page.goto(MODULES.beacon);
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost');
  expect(currentUrl).to.not.include('localhost:3703');
});

Then('devo ver a mensagem {string}', async function(message) {
  await page.waitForSelector('.error-message');
  const errorText = await page.evaluate(() => {
    return document.querySelector('.error-message').textContent;
  });
  expect(errorText).to.include(message);
});

Then('devo permanecer na página de login', async function() {
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost');
  expect(currentUrl).to.not.include('localhost:3701');
  
  const loginForm = await page.evaluate(() => {
    return document.querySelector('.login-container') !== null;
  });
  expect(loginForm).to.be.true;
});

Then('devo ser redirecionado para o Harbor \\(fallback\\)', async function() {
  await page.waitForNavigation();
  const currentUrl = await page.url();
  expect(currentUrl).to.include('localhost:3701');
}); 