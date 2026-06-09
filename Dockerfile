# 1. FÁZE: Sestavení (Build) Flutter Web aplikace
FROM ubuntu:22.04 AS build

# Instalace potřebných závislostí pro Linux a Git
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Konfigurace Gitu pro bezpečný přístup v Dockeru
RUN git config --global --add safe.directory '*'

# Stažení stabilní verze Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable

# Nastavení cest do systému (PATH)
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

# Ověření instalace a povolení webu
RUN flutter doctor
RUN flutter config --enable-web

# Nastavení pracovního adresáře a zkopírování kódu
WORKDIR /app
COPY . .

# Stažení balíčků a sestavení produkčního webu přímo v kořeni aplikaci
RUN env "PATH=$PATH" flutter pub get
RUN env "PATH=$PATH" flutter build web --release

# 2. FÁZE: Spuštění pomocí lehkého webového serveru Nginx
FROM nginx:alpine

# Zkopírování hotového webu z první fáze (build) přímo do Nginxu
COPY --from=build /app/build/web /usr/share/nginx/html

# Otevření portu 80 pro Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]