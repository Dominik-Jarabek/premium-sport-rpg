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

# Nastavení cest do systému (PATH) - Včetně explicitního přidání standardních Linux binárek, kde žije git
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

# Ověření instalace a povolení webu
RUN flutter doctor
RUN flutter config --enable-web

# Přepnutí do podsložky a sestavení webu
WORKDIR /app/premium_sport_rpg_app

# Spuštění s explicitním zachováním PATH prostředí pro Flutter i Git
RUN env "PATH=$PATH" flutter pub get
RUN env "PATH=$PATH" flutter build web --release

# Speciální trik: Najdeme vygenerovanou složku 'web' a přesuneme ji na pevné místo do /app/final_web
RUN mkdir -p /app/final_web && cp -r $(find /app/premium_sport_rpg_app/build -type d -name "web" | head -n 1)/* /app/final_web/

# 2. FÁZE: Spuštění pomocí lehkého webového serveru Nginx
FROM nginx:alpine
# Kopírujeme z garantovaného místa /app/final_web
COPY --from=build /app/final_web /usr/share/nginx/html

# Otevření portu 80 pro Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]