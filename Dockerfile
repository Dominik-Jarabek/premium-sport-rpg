# ==========================
# BUILD FLUTTER WEB
# ==========================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Zkopírování projektu
COPY . .

# Povolení Flutter Web
RUN flutter config --enable-web

# Stažení balíčků
RUN flutter pub get

# Build produkční verze
RUN flutter build web --release

# ==========================
# NGINX SERVER
# ==========================
FROM nginx:alpine

# Zkopírování sestaveného webu
COPY --from=build /app/build/web /usr/share/nginx/html

# Port pro Render
EXPOSE 80

# Spuštění nginx
CMD ["nginx", "-g", "daemon off;"]