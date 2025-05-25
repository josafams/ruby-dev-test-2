FROM ubuntu:20.04

ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV RUBY_VERSION=2.4.1
ENV APP_HOME=/app

# Instala dependências
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    git \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libgdbm-dev \
    libncurses5-dev \
    libffi-dev \
    libgmp-dev \
    autoconf \
    bison \
    libsqlite3-dev \
    sqlite3 \
    ca-certificates \
    tzdata \
    nodejs \
    npm \
    yarn \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Compila e instala o Ruby 2.4.1
RUN curl -fsSL https://cache.ruby-lang.org/pub/ruby/2.4/ruby-${RUBY_VERSION}.tar.gz | tar xz -C /tmp && \
    cd /tmp/ruby-${RUBY_VERSION} && \
    ./configure --disable-install-doc && \
    make -j"$(nproc)" && \
    make install && \
    cd / && rm -rf /tmp/ruby-${RUBY_VERSION}

# Instala bundler compatível
RUN gem install bundler -v 2.1.4

# Cria usuário não root
RUN groupadd -g ${GROUP_ID} railsuser && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash railsuser && \
    echo "railsuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p $APP_HOME && chown -R railsuser:railsuser $APP_HOME

WORKDIR $APP_HOME
USER railsuser

# Copia arquivos da aplicação
COPY --chown=railsuser:railsuser Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=railsuser:railsuser . .

EXPOSE 3000
CMD ["bash"]
