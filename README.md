# graphene-django-cookbook

Seguindo o tutorial de como conectar ORM aos tipos de objetos Graphene<sup id="id1">[1](#graphene-django)</sup>.

É possível rodar esse projeto com ou sem Docker. Recomendo fortemente o uso do docker, para assim garantir resultados, independentemente do sistema usado.

Nesse repositório usaremos boas práticas como ambientes virtual, variáveis de ambiente (sim, eu também já cometi o erro de versionar chaves secretas), criações de chaves (o ideal é ter uma chave para Desenvolvimento, Homologação e Desenvolvimento) e .gitignore (não cometa o erro de subir arquivos desnecessários)

## Variáveis de ambiente

Nesse projeto, usaremos as variáveis de ambiente:

- DEBUG (Para ativar o debug. Ativado por padrão)
- ALLOWED_HOSTS (Para produção, `DEBUG` não será `TRUE` e deveremos informar as hosts usadas, separando por `;`)
- SECRET_KEY (chave secreta para projetos Django)

Para o Python extrair os valores, deve-se copiar o arquivo `.env.example` para `.env` (Ex: `cp .env.example .env`) e modificar os valores das variáveis nesse novo arquivo.

Para criar a `SECRET_KEY` para o Django

```bash
python3 -c "import secrets; print(secrets.token_urlsafe())"
```

## Rodando o projeto (sem Docker)

Como boa prática, o ideal é criar um ambiente de desenvolvimentos isolados com [virtualenv](https://pypi.org/project/virtualenv/). 


### Instalando dependências

Supondo que já tenhas o `virtualenv` instalado em sua máquina, para instalar as dependências do projeto (exemplo num terminal Linux)

```bash
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
```

### Iniciando o servidor

Para iniciar o servidor

```bash
python manage.py runserver
```

O servidor servidor estará em http://127.0.0.1:8000/


### Inserindo dados de teste

Ainda não temos dados no nosso banco. Mas antes de carregar qualquer dado, precisamos criar nossa tabela com os nossos models

```bash
python manage.py makemigrations ingredients
python manage.py migrate
```

Em [cookbook/ingredients/fixtures](https://github.com/cauachagas/graphene-django-cookbook/tree/main/cookbook/ingredients/fixtures) temos um arquivo [ingredients.json](https://raw.githubusercontent.com/cauachagas/graphene-django-cookbook/main/cookbook/ingredients/fixtures/ingredients.json) que serve como dado inicial.

Para carregar esse dado

```bash
python manage.py loaddata ingredients
```

## Rodando o projeto (com Docker)

Eu poderia disponibilizar uma imagem Docker com todos os passos finalizados, mas por questões de didática, mostrarei como fazê-los.

Supondo que já tenhas o Docker e Docker Compose instalados, para a construção da nossa imagem iremos precisar das variáveis de ambiente, como visto num dos [tópico anteriores](#vari%C3%A1veis-de-ambiente). 

Para não repetitivo, podemos condensar os passos

0. Configure as [variáveis de ambiente](#vari%C3%A1veis-de-ambiente) no arquivo `.env`
1. `docker-compose build` (Construindo nossa imagem)
2. `docker-compose run web bash` (Acessando o bash num container)
3. `python manage.py makemigrations ingredients` (Criando os modelos e faz as migrações)
4. `python manage.py migrate` (Aplica as alterações no banco de dados)
5. `python manage.py loaddata ingredients` (Carrega os dados em fixtures)
6. `Ctrl+D` (Sair do container)


Agora basta usar

```bash
docker-compose up
```

para iniciar o projeto. 

Para pausar o processo, use `Ctrl+C` e depois `docker-compose down`

Para iniciar o container em segundo plano para ter acesso ao mesmo terminal `docker-compose up -d`. E novamente, para pausar `docker-compose down`. 


### Usando GraphiQL

Em seu localhost, vá para a rota `graphql`. Veja como o poder do GraphQL em ação

![](https://media.giphy.com/media/MlzgkOqT8Ri4KFv3HH/giphy.gif)


Você pode notar que o GraphQL só traz o que pedimos. Nem mais, nem menos. Numa API para o mundo real, facilita bastante quando é necessário fazer nas filtragens de dados, sem precisar passar por vários endpoints.


### Criando super usuário (Opcional)

Caso você queira acessar o painel administrativo na rota `admin`, precisamos criar um super usuário. Isso poderá ser feito iterativamente com

```bash
python manage.py createsuperuser
```

ou pelo terminal Python usando `python manage.py shell` com o seguinte script

```bash
from django.contrib.auth.models import User
user=User.objects.create_user('foo', password='bar')
user.is_superuser = True
user.is_staff = True
user.save()
```

onde criamos um super usuário (`user.is_superuser = True`) de nome `foo` com senha `bar` e lhe foi dado permissão ao painel administrativo (`user.is_staff = True`).

![](https://drive.google.com/uc?export=view&id=1GdJvHPn3mlMpE6h3yd2m4Yii1IiKISj8)


# Referências

1. <b id="graphene-django"></b> https://docs.graphene-python.org/projects/django/en/latest/tutorial-plain [↩](#id1) 
