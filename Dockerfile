# 1. FÁZE: Sestavení (Build) Flutter Web aplikace pomocí oficiálního/ověřeného obrazu
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Nastavení pracovního adresáře uvnitř kontejneru
WORKDIR /app

# Zkopírování zdrojového kódu projektu
COPY . .

# Stažení balíčků a sestavení produkčního webu
RUN flutter pub get
RUN flutter build web --release

# 2. FÁZE: Spuštění pomocí lehkého webového serveru Nginx
FROM nginx:alpine

# Zkopírování hotového webu z první fáze (build) do Nginxu
COPY --from=build /app/build/web /usr/share/nginx/html

# Otevření portu 80 pro Render
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]