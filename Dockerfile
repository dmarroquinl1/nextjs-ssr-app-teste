# === STAGE 1: BUILD ===
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# === STAGE 2: PRODUCTION RUNTIME CON PM2 ===
FROM node:20-alpine AS runtime
WORKDIR /app

# Instalar PM2 globalmente en el runtime stage
RUN npm install -g pm2

# Configuración de seguridad: Usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copiamos solo los archivos necesarios para ejecutar con PM2
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY ecosystem.config.js ./ecosystem.config.js
COPY package.json ./package.json

EXPOSE 3000

# Comando de arranque usando PM2 runtime
CMD ["pm2-runtime", "ecosystem.config.js"]