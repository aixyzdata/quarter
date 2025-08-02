# language: pt
Funcionalidade: Login e Redirecionamento do Quarter
  Como um usuário do sistema Canonika
  Eu quero fazer login através do Quarter
  Para que eu possa acessar outros módulos do sistema

  Contexto:
    Dado que estou na página de login do Quarter
    E que não estou autenticado

  Cenário: Login direto no Quarter
    Quando eu preencho o email com "admin@canonika.io"
    E preencho a senha com "admin123"
    E clico no botão "ENTRAR"
    Então devo ser redirecionado para o Harbor
    E minha sessão deve ser preservada

  Cenário: Login a partir do Beacon
    Dado que estou acessando o Beacon sem autenticação
    Quando sou redirecionado para o Quarter com redirect_to
    E preencho o email com "admin@canonika.io"
    E preencho a senha com "admin123"
    E clico no botão "ENTRAR"
    Então devo ser redirecionado de volta para o Beacon
    E minha sessão deve ser preservada
    E devo ver a interface do Beacon

  Cenário: Login a partir do Skipper
    Dado que estou acessando o Skipper sem autenticação
    Quando sou redirecionado para o Quarter com redirect_to
    E preencho o email com "admin@canonika.io"
    E preencho a senha com "admin123"
    E clico no botão "ENTRAR"
    Então devo ser redirecionado de volta para o Skipper
    E minha sessão deve ser preservada
    E devo ver a interface do Skipper

  Cenário: Login a partir do Harbor
    Dado que estou acessando o Harbor sem autenticação
    Quando sou redirecionado para o Quarter com redirect_to
    E preencho o email com "admin@canonika.io"
    E preencho a senha com "admin123"
    E clico no botão "ENTRAR"
    Então devo ser redirecionado de volta para o Harbor
    E minha sessão deve ser preservada
    E devo ver a interface do Harbor

  Cenário: Preservação de sessão entre módulos
    Dado que estou logado no Quarter
    Quando acesso o Beacon
    Então devo ver a interface do Beacon sem precisar fazer login novamente
    Quando acesso o Skipper
    Então devo ver a interface do Skipper sem precisar fazer login novamente
    Quando acesso o Harbor
    Então devo ver a interface do Harbor sem precisar fazer login novamente

  Cenário: Logout global
    Dado que estou logado em qualquer módulo
    Quando faço logout
    Então devo ser redirecionado para o Quarter
    E minha sessão deve ser limpa
    E não devo conseguir acessar outros módulos sem fazer login novamente

  Cenário: Credenciais inválidas
    Dado que estou na página de login do Quarter
    Quando preencho o email com "usuario@invalido.com"
    E preencho a senha com "senhaerrada"
    E clico no botão "ENTRAR"
    Então devo ver a mensagem "Credenciais inválidas"
    E devo permanecer na página de login

  Cenário: URL de redirect_to inválida
    Dado que estou na página de login do Quarter com redirect_to inválido
    Quando preencho as credenciais corretas
    E clico no botão "ENTRAR"
    Então devo ser redirecionado para o Harbor (fallback)
    E minha sessão deve ser preservada 