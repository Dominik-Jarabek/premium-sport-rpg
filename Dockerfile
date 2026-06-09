# 1. FÁZE: Sestavení (Build) Flutter Web aplikace
FROM ubuntu:22.04 AS build

# Instalace potřebných závislostí pro Linux (přidáno ca-certificates)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Stažení stabilní verze Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter -b stable

# --- OPRAVA CHYBY ---
# Povolení bezpečného adresáře pro Git (řeší pád 'flutter doctor' v Dockeru)
RUN git config --global --add safe.directory /usr/local/flutter

# Nastavení cest do systému (PATH)
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Ověření instalace a povolení webu (přidáno vypnutí analytiky)
RUN flutter doctor
RUN flutter config --enable-web --no-analytics

# Nastavení pracovního adresáře a zkopírování kódu
WORKDIR /app
COPY . .

# Stažení balíčků a sestavení produkčního webu
RUN flutter pub get
RUN flutter build web --release

# 2. FÁZE: Spuštění pomocí lehkého webového serveru Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Otevření portu 80 pro Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]