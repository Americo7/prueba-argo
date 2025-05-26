# Etapa de construcción
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./
COPY tsconfig*.json ./
COPY nest-cli.json ./

# Instalar dependencias
RUN npm ci

# Copiar código fuente
COPY src/ ./src/

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:18-alpine AS production

WORKDIR /app

# Instalar dumb-init
RUN apk add --no-cache dumb-init

# Crear usuario no root
RUN addgroup -g 1001 -S nodejs && adduser -S nestjs -u 1001

# Copiar package.json
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production && npm cache clean --force

# Copiar aplicación construida
COPY --from=builder /app/dist ./dist

# Cambiar propietario
RUN chown -R nestjs:nodejs /app

USER nestjs

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"]
