# 1. FÁZE: Sestavení (Build) Flutter Web aplikace
FROM ubuntu:22.04 AS build

# Instalace potřebných závislostí pro Linux
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Stažení stabilní verze Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable

# Nastavení cest do systému (PATH)
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Ověření instalace a povolení webu
RUN flutter doctor
RUN flutter config --enable-web

# Nastavení pracovního adresáře a zkopírování kódu
WORKDIR /app
COPY . .

# PŘEPNUTÍ DO PODSLOŽKY S PROJEKTEM (Zde se nachází pubspec.yaml a lib)
WORKDIR /app/premium_sport_rpg

# Stažení balíčků a sestavení produkčního webu
RUN flutter pub get
RUN flutter build web --release

# 2. FÁZE: Spuštění pomocí lehkého webového serveru Nginx
FROM nginx:alpine
# Kopírování zkompilovaného webu ze správné podsložky
COPY --from=build /app/premium_sport_rpg/build/web /usr/share/nginx/html

# Otevření portu 80 pro Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]