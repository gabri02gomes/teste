# Etapa 1: Imagem Base
FROM ruby:3.2.2

# Etapa 2: Instalação de Dependências do Sistema
RUN apt-get update -qq && apt-get install -y build-essential libvips default-libmysqlclient-dev

# Etapa 3: Criação do Usuário da Aplicação
ARG UID
ARG GID
RUN groupadd --gid ${GID:-1000} rails \
    && useradd --uid ${UID:-1001} --gid ${GID:-1000} --create-home --shell /bin/bash rails

# Etapa 4: Configuração do Ambiente da Aplicação
WORKDIR /myapp
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

# Etapa 5: Ajuste Final de Permissões
RUN chown -R rails:rails /myapp

# Muda o usuário padrão do contêiner para 'rails'
USER rails

# Etapa 6: Execução
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
