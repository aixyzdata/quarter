#!/usr/bin/env node

const puppeteer = require('puppeteer');

async function testRedirect() {
  console.log('🧪 Testando mecanismo de redirect_to...');
  
  const browser = await puppeteer.launch({ 
    headless: false,
    slowMo: 1000 
  });
  
  try {
    const page = await browser.newPage();
    
    // Teste 1: Acessar Beacon
    console.log('📡 Acessando Beacon...');
    await page.goto('http://localhost:3703');
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // Verificar se foi redirecionado para Quarter
    const currentUrl = await page.url();
    console.log('📍 URL atual:', currentUrl);
    
    if (currentUrl.includes('localhost') && !currentUrl.includes('3703')) {
      console.log('✅ Beacon redirecionou para Quarter');
      
      // Verificar se tem redirect_to
      if (currentUrl.includes('redirect_to')) {
        console.log('✅ Parâmetro redirect_to presente');
      } else {
        console.log('❌ Parâmetro redirect_to ausente');
      }
    } else {
      console.log('❌ Beacon não redirecionou corretamente');
    }
    
    // Teste 2: Fazer login no Quarter
    console.log('🔐 Fazendo login no Quarter...');
    await page.waitForSelector('input[type="email"]');
    await page.type('input[type="email"]', 'admin@canonika.io');
    await page.type('input[type="password"]', 'admin123');
    await page.click('.login-btn');
    
    await new Promise(resolve => setTimeout(resolve, 3000));
    
    // Verificar se foi redirecionado de volta
    const finalUrl = await page.url();
    console.log('📍 URL final:', finalUrl);
    
    if (finalUrl.includes('localhost:3703')) {
      console.log('✅ Login redirecionou de volta para Beacon');
    } else if (finalUrl.includes('localhost:3701')) {
      console.log('✅ Login redirecionou para Harbor (fallback)');
    } else {
      console.log('❌ Login não redirecionou corretamente');
    }
    
  } catch (error) {
    console.error('❌ Erro durante o teste:', error.message);
  } finally {
    await browser.close();
  }
}

testRedirect(); 