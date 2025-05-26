#!/bin/bash

# ============================================
# PROYECTO NESTJS COMPLETO PARA ARGO WORKFLOWS
# Usuario: Americo7
# Repo: prueba-argo
# Registry: Docker Hub (americo7)
# ============================================

PROJECT_NAME="prueba-argo"
GITHUB_USER="Americo7"
DOCKER_USER="americo7"
DOCKER_REGISTRY="docker.io"
ARGO_SERVER="http://localhost:2746"

echo "🚀 Creando proyecto: $PROJECT_NAME"
echo "👤 Usuario GitHub: $GITHUB_USER"
echo "🐳 Docker Registry: $DOCKER_REGISTRY/$DOCKER_USER"
echo "⚙️  Argo Server: $ARGO_SERVER"
echo ""

# Crear estructura de directorios
mkdir -p $PROJECT_NAME/{src,k8s,workflows,.github/workflows,scripts}

# ============ PACKAGE.JSON ============
cat > $PROJECT_NAME/package.json << 'EOF'
{
  "name": "prueba-argo",
  "version": "1.0.0",
  "description": "NestJS app con despliegue automático usando Argo Workflows",
  "main": "dist/main.js",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\"",
    "start": "node dist/main",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.2",
    "@types/node": "^20.3.1",
    "@types/supertest": "^2.0.12",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "source-map-support": "^0.5.21",
    "supertest": "^6.3.3",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.1",
    "typescript": "^5.1.3"
  },
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": { "^.+\\.(t|j)s$": "ts-jest" },
    "collectCoverageFrom": ["**/*.(t|j)s"],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
EOF

# ============ TYPESCRIPT CONFIG ============
cat > $PROJECT_NAME/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2020",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
EOF

# ============ NEST CLI CONFIG ============
cat > $PROJECT_NAME/nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
EOF

# ============ MAIN.TS ============
cat > $PROJECT_NAME/src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.enableCors();
  
  const port = process.env.PORT || 3000;
  
  await app.listen(port);
  console.log(`🚀 Aplicación ejecutándose en puerto ${port}`);
  console.log(`📋 Health check: http://localhost:${port}/health`);
  console.log(`📊 Info: http://localhost:${port}/info`);
}

bootstrap();
EOF

# ============ APP.MODULE.TS ============
cat > $PROJECT_NAME/src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
EOF

# ============ APP.CONTROLLER.TS ============
cat > $PROJECT_NAME/src/app.controller.ts << 'EOF'
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('health')
  getHealth(): object {
    return this.appService.getHealth();
  }

  @Get('info')
  getInfo(): object {
    return this.appService.getInfo();
  }
}
EOF

# ============ APP.SERVICE.TS ============
cat > $PROJECT_NAME/src/app.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return '🎉 ¡Hola Américo! Tu app NestJS está funcionando en Kubernetes con Argo Workflows!';
  }

  getHealth(): object {
    return {
      status: 'OK',
      message: 'Aplicación saludable',
      timestamp: new Date().toISOString(),
      uptime: Math.floor(process.uptime()),
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'production',
      memory: {
        used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB',
        total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024) + ' MB'
      }
    };
  }

  getInfo(): object {
    return {
      app: 'Prueba Argo - NestJS',
      version: '1.0.0',
      author: 'Americo7',
      description: 'Aplicación de prueba para despliegue con Argo Workflows',
      endpoints: [
        { path: '/', method: 'GET', description: 'Mensaje de bienvenida' },
        { path: '/health', method: 'GET', description: 'Estado de salud de la aplicación' },
        { path: '/info', method: 'GET', description: 'Información de la aplicación' }
      ],
      deployment: {
        platform: 'Kubernetes',
        cicd: 'Argo Workflows',
        registry: 'Docker Hub'
      }
    };
  }
}
EOF

# ============ TESTS ============
cat > $PROJECT_NAME/src/app.controller.spec.ts << 'EOF'
import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('should return welcome message', () => {
      expect(appController.getHello()).toContain('Américo');
    });
  });

  describe('health', () => {
    it('should return health status', () => {
      const health = appController.getHealth();
      expect(health).toHaveProperty('status', 'OK');
    });
  });

  describe('info', () => {
    it('should return app info', () => {
      const info = appController.getInfo();
      expect(info).toHaveProperty('app', 'Prueba Argo - NestJS');
      expect(info).toHaveProperty('author', 'Americo7');
    });
  });
});
EOF

# ============ DOCKERFILE ============
cat > $PROJECT_NAME/Dockerfile << 'EOF'
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
EOF

# ============ .DOCKERIGNORE ============
cat > $PROJECT_NAME/.dockerignore << 'EOF'
node_modules
npm-debug.log
Dockerfile
.dockerignore
.git
.gitignore
README.md
.env
coverage
.vscode
.github
workflows
k8s
scripts
*.md
EOF

# ============ KUBERNETES MANIFESTS ============

# Namespace
cat > $PROJECT_NAME/k8s/namespace.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: prueba-argo
  labels:
    name: prueba-argo
    managed-by: argo-workflows
    app: nestjs-app
EOF

# ConfigMap
cat > $PROJECT_NAME/k8s/configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nestjs-config
  namespace: prueba-argo
data:
  NODE_ENV: "production"
  LOG_LEVEL: "info"
  PORT: "3000"
EOF

# Deployment
cat > $PROJECT_NAME/k8s/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nestjs-app
  namespace: prueba-argo
  labels:
    app: nestjs-app
    version: v1
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: nestjs-app
  template:
    metadata:
      labels:
        app: nestjs-app
        version: v1
      annotations:
        prometheus.io/scrape: "false"
    spec:
      containers:
      - name: nestjs-app
        image: __IMAGE_TAG__
        ports:
        - containerPort: 3000
          protocol: TCP
        env:
        - name: NODE_ENV
          valueFrom:
            configMapKeyRef:
              name: nestjs-config
              key: NODE_ENV
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: nestjs-config
              key: PORT
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
            httpHeaders:
            - name: Custom-Header
              value: HealthCheck
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          successThreshold: 1
          failureThreshold: 3
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        securityContext:
          runAsNonRoot: true
          runAsUser: 1001
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
EOF

# Service
cat > $PROJECT_NAME/k8s/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nestjs-service
  namespace: prueba-argo
  labels:
    app: nestjs-app
spec:
  selector:
    app: nestjs-app
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 3000
  type: ClusterIP
EOF

# ============ ARGO WORKFLOW ============
cat > $PROJECT_NAME/workflows/ci-cd-workflow.yaml << EOF
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: prueba-argo-ci-cd-
  namespace: argo
  labels:
    app: prueba-argo-ci-cd
    owner: americo7
spec:
  entrypoint: ci-cd-pipeline
  arguments:
    parameters:
    - name: repo-url
      value: "https://github.com/$GITHUB_USER/$PROJECT_NAME.git"
    - name: branch
      value: "main"
    - name: image-tag
      value: "latest"
    - name: registry-url
      value: "$DOCKER_REGISTRY/$DOCKER_USER"

  volumeClaimTemplates:
  - metadata:
      name: workspace
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 2Gi

  templates:
  - name: ci-cd-pipeline
    dag:
      tasks:
      - name: clone-repo
        template: git-clone
      - name: run-tests
        template: run-tests
        dependencies: [clone-repo]
      - name: build-image
        template: docker-build
        dependencies: [run-tests]
      - name: deploy-to-k8s
        template: k8s-deploy
        dependencies: [build-image]

  - name: git-clone
    container:
      image: alpine/git:latest
      command: [sh, -c]
      args:
        - |
          echo "🔄 Clonando repositorio de $GITHUB_USER..."
          git clone {{workflow.parameters.repo-url}} /workspace
          cd /workspace
          git checkout {{workflow.parameters.branch}}
          echo "✅ Repositorio clonado exitosamente"
          echo "📁 Contenido del workspace:"
          ls -la
      volumeMounts:
      - name: workspace
        mountPath: /workspace

  - name: run-tests
    container:
      image: node:18-alpine
      command: [sh, -c]
      args:
        - |
          echo "🧪 Ejecutando tests para $PROJECT_NAME..."
          cd /workspace
          npm ci
          npm run test
          echo "✅ Tests completados exitosamente"
      volumeMounts:
      - name: workspace
        mountPath: /workspace

  - name: docker-build
    container:
      image: gcr.io/kaniko-project/executor:latest
      args:
        - "--context=/workspace"
        - "--dockerfile=/workspace/Dockerfile"
        - "--destination={{workflow.parameters.registry-url}}/$PROJECT_NAME:{{workflow.parameters.image-tag}}"
        - "--destination={{workflow.parameters.registry-url}}/$PROJECT_NAME:latest"
        - "--cache=true"
        - "--cache-ttl=24h"
        - "--skip-tls-verify"
      volumeMounts:
      - name: workspace
        mountPath: /workspace
      - name: docker-config
        mountPath: /kaniko/.docker

  - name: k8s-deploy
    container:
      image: bitnami/kubectl:latest
      command: [sh, -c]
      args:
        - |
          echo "🚀 Desplegando $PROJECT_NAME en Kubernetes..."
          
          # Aplicar namespace
          echo "📦 Creando namespace..."
          kubectl apply -f /workspace/k8s/namespace.yaml
          
          # Aplicar ConfigMap
          echo "⚙️  Aplicando configuración..."
          kubectl apply -f /workspace/k8s/configmap.yaml
          
          # Reemplazar imagen en deployment
          echo "🔄 Configurando imagen: {{workflow.parameters.registry-url}}/$PROJECT_NAME:{{workflow.parameters.image-tag}}"
          sed -i 's|__IMAGE_TAG__|{{workflow.parameters.registry-url}}/$PROJECT_NAME:{{workflow.parameters.image-tag}}|g' /workspace/k8s/deployment.yaml
          
          # Aplicar manifiestos
          echo "📋 Aplicando deployment y service..."
          kubectl apply -f /workspace/k8s/deployment.yaml
          kubectl apply -f /workspace/k8s/service.yaml
          
          # Esperar deployment
          echo "⏳ Esperando que el deployment esté listo (máximo 5 minutos)..."
          kubectl rollout status deployment/nestjs-app -n $PROJECT_NAME --timeout=300s
          
          # Verificar estado
          echo "📊 Estado final:"
          kubectl get pods,svc -n $PROJECT_NAME
          
          # Mostrar logs de los pods
          echo "📝 Logs de la aplicación:"
          kubectl logs -l app=nestjs-app -n $PROJECT_NAME --tail=10
          
          echo "✅ ¡Despliegue de $PROJECT_NAME completado exitosamente!"
          echo "🔗 Para acceder: kubectl port-forward service/nestjs-service 8080:80 -n $PROJECT_NAME"
      volumeMounts:
      - name: workspace
        mountPath: /workspace

  volumes:
  - name: docker-config
    secret:
      secretName: docker-config
EOF

# ============ GITHUB ACTIONS ============
cat > $PROJECT_NAME/.github/workflows/ci-cd.yaml << EOF
name: 🚀 CI/CD Pipeline con Argo Workflows

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: $DOCKER_REGISTRY
  REGISTRY_USER: $DOCKER_USER
  PROJECT_NAME: $PROJECT_NAME

jobs:
  trigger-argo-workflow:
    name: 🎯 Disparar Argo Workflow
    runs-on: ubuntu-latest
    steps:
    - name: 📥 Checkout código
      uses: actions/checkout@v4

    - name: 🏷️ Configurar variables
      id: vars
      run: |
        echo "SHORT_SHA=\${GITHUB_SHA::8}" >> \$GITHUB_OUTPUT
        echo "BRANCH_NAME=\${GITHUB_REF#refs/heads/}" >> \$GITHUB_OUTPUT
        echo "IMAGE_TAG=\${GITHUB_SHA::8}" >> \$GITHUB_OUTPUT
        echo "TIMESTAMP=\$(date +%Y%m%d-%H%M%S)" >> \$GITHUB_OUTPUT

    - name: 📋 Mostrar información
      run: |
        echo "🎯 Proyecto: \$PROJECT_NAME"
        echo "👤 Usuario: $GITHUB_USER"
        echo "🐳 Registry: \$REGISTRY/\$REGISTRY_USER"
        echo "🌿 Branch: \${{ steps.vars.outputs.BRANCH_NAME }}"
        echo "🏷️ Tag: \${{ steps.vars.outputs.IMAGE_TAG }}"

    - name: 🛠️ Instalar Argo CLI
      run: |
        echo "📦 Descargando Argo CLI..."
        curl -sLO https://github.com/argoproj/argo-workflows/releases/latest/download/argo-linux-amd64.gz
        gunzip argo-linux-amd64.gz
        chmod +x argo-linux-amd64
        sudo mv argo-linux-amd64 /usr/local/bin/argo
        echo "✅ Argo CLI instalado:"
        argo version

    - name: 🚀 Ejecutar Argo Workflow
      run: |
        echo "🎯 Enviando workflow a Argo..."
        argo submit workflows/ci-cd-workflow.yaml \\
          --parameter repo-url=\${{ github.event.repository.clone_url }} \\
          --parameter branch=\${{ steps.vars.outputs.BRANCH_NAME }} \\
          --parameter image-tag=\${{ steps.vars.outputs.IMAGE_TAG }} \\
          --parameter registry-url=\$REGISTRY/\$REGISTRY_USER \\
          --server \${{ secrets.ARGO_SERVER }} \\
          --token \${{ secrets.ARGO_TOKEN }} \\
          --name $PROJECT_NAME-\${{ steps.vars.outputs.TIMESTAMP }}-\${{ steps.vars.outputs.SHORT_SHA }} \\
          --wait \\
          --log
      env:
        ARGO_SERVER: \${{ secrets.ARGO_SERVER }}
        ARGO_TOKEN: \${{ secrets.ARGO_TOKEN }}

    - name: 📊 Estado del workflow
      if: always()
      run: |
        echo "📋 Resumen del despliegue:"
        echo "  ✅ Proyecto: $PROJECT_NAME"
        echo "  ✅ Usuario: $GITHUB_USER"  
        echo "  ✅ Imagen: \$REGISTRY/\$REGISTRY_USER/$PROJECT_NAME:\${{ steps.vars.outputs.IMAGE_TAG }}"
        echo "  ✅ Branch: \${{ steps.vars.outputs.BRANCH_NAME }}"
        echo ""
        echo "🔗 Para probar la aplicación:"
        echo "kubectl port-forward service/nestjs-service 8080:80 -n $PROJECT_NAME"
        echo "curl http://localhost:8080"
EOF

# ============ GITIGNORE ============
cat > $PROJECT_NAME/.gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# NYC test coverage
.nyc_output

# Grunt intermediate storage
.grunt

# Bower dependency directory
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons
build/Release

# Dependency directories
jspm_packages/

# TypeScript v1 declaration files
typings/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env.production

# parcel-bundler cache
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log

# Build output
dist/
build/
EOF

# ============ SCRIPTS DE CONFIGURACIÓN ============

# Script principal de setup
cat > $PROJECT_NAME/scripts/setup-complete.sh << EOF
#!/bin/bash

echo "🚀 CONFIGURACIÓN AUTOMÁTICA PARA $GITHUB_USER"
echo "=================================="
echo "📦 Proyecto: $PROJECT_NAME"
echo "🐳 Registry: $DOCKER_REGISTRY/$DOCKER_USER"
echo "⚙️  Argo Server: $ARGO_SERVER"
echo ""

# Verificar kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl no encontrado. Por favor instálalo primero."
    exit 1
fi

# Verificar conexión al cluster
echo "🔍 Verificando conexión al cluster..."
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ No se puede conectar al cluster de Kubernetes"
    echo "   Asegúrate de que kubectl esté configurado correctamente"
    exit 1
fi

echo "✅ Conexión al cluster verificada"

# Crear namespace argo si no existe
echo "📦 Verificando namespace argo..."
kubectl create namespace argo --dry-run=client -o yaml | kubectl apply -f -

# Crear secreto de Docker Hub
echo "🔐 Configurando autenticación de Docker Hub..."
echo "ℹ️  Se necesitan tus credenciales de Docker Hub"

while true; do
    read -s -p "🔑 Password de Docker Hub para usuario '$DOCKER_USER': " DOCKER_PASSWORD
    echo
    
    if [[ -n "\$DOCKER_PASSWORD" ]]; then
        break
    else
        echo "❌ Password no puede estar vacío"
    fi
done

# Crear o actualizar el secreto
kubectl create secret docker-registry docker-config \\
  --docker-server=$DOCKER_REGISTRY \\
  --docker-username=$DOCKER_USER \\
  --docker-password="\$DOCKER_PASSWORD" \\
  --docker-email=$DOCKER_USER@email.com \\
  -n argo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Secreto de Docker configurado"

# Crear ServiceAccount
echo "👤 Configurando ServiceAccount..."
kubectl create serviceaccount argo-workflow -n argo --dry-run=client -o yaml | kubectl apply -f -

# Crear ClusterRoleBinding
echo "🔑 Configurando permisos..."
kubectl create clusterrolebinding argo-workflow-admin \\
  --clusterrole=cluster-admin \\
  --serviceaccount=argo:argo-workflow \\
  --dry-run=client -o yaml | kubectl apply -f -

# Generar token de larga duración
echo "🎫 Generando token de acceso..."
TOKEN=\$(kubectl create token argo-workflow -n argo --duration=8760h)

if [[ -z "\$TOKEN" ]]; then
    echo "❌ Error generando token"
    exit 1
fi

echo "✅ Token generado exitosamente"
echo ""
echo "🎯 CONFIGURACIÓN COMPLETADA"
echo "=========================="
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo ""
echo "1️⃣  Agregar secrets en GitHub ($GITHUB_USER/$PROJECT_NAME):"
echo "   Ve a: Settings → Secrets and variables → Actions"
echo ""
echo "   🔑 ARGO_SERVER = $ARGO_SERVER"
echo "   🔑 ARGO_TOKEN = \$TOKEN"
echo ""
echo "2️⃣  Hacer push del código:"
echo "   cd $PROJECT_NAME"
echo "   git add ."
echo "   git commit -m '🚀 Initial commit - NestJS app con Argo Workflows'"
echo "   git push origin main"
echo ""
echo "3️⃣  El pipeline se ejecutará automáticamente al hacer push!"
echo ""
echo "4️⃣  Para probar la app desplegada:"
echo "   kubectl port-forward service/nestjs-service 8080:80 -n $PROJECT_NAME"
echo "   curl http://localhost:8080"
echo ""
echo "🔗 URLs útiles:"
echo "   • Argo UI: $ARGO_SERVER"
echo "   • GitHub: https://github.com/$GITHUB_USER/$PROJECT_NAME"
echo "   • Docker Hub: https://hub.docker.com/r/$DOCKER_USER/$PROJECT_NAME"
echo ""
echo "✅ ¡Todo listo para usar!"

# Guardar token en archivo para referencia
echo "\$TOKEN" > ../argo-token.txt
echo "💾 Token guardado en: ../argo-token.txt"
EOF

chmod +x $PROJECT_NAME/scripts/setup-complete.sh

# Script para despliegue manual rápido
cat > $PROJECT_NAME/scripts/deploy-manual.sh << EOF
#!/bin/bash

echo "🚀 DESPLIEGUE MANUAL RÁPIDO"
echo "========================="

IMAGE_TAG=\${1:-latest}
echo "🏷️ Usando imagen: $DOCKER_REGISTRY/$DOCKER_USER/$PROJECT_NAME:\$IMAGE_TAG"

# Aplicar manifiestos
echo "📦 Aplicando namespace..."
kubectl apply -f ../k8s/namespace.yaml

echo "⚙️ Aplicando configuración..."
kubectl apply -f ../k8s/configmap.yaml

echo "🔄 Configurando imagen en deployment..."
sed "s|__IMAGE_TAG__|$DOCKER_REGISTRY/$DOCKER_USER/$PROJECT_NAME:\$IMAGE_TAG|g" ../k8s/deployment.yaml | kubectl apply -f -

echo "🌐 Aplicando service..."
kubectl apply -f ../k8s/service.yaml

echo "⏳ Esperando deployment..."
kubectl rollout status deployment/nestjs-app -n $PROJECT_NAME --timeout=300s

echo "📊 Estado:"
kubectl get pods,svc -n $PROJECT_NAME

echo "✅ ¡Listo! Para probar:"
echo "kubectl port-forward service/nestjs-service 8080:80 -n $PROJECT_NAME"
EOF

chmod +x $PROJECT_NAME/scripts/deploy-manual.sh

# ============ README.MD ============
cat > $PROJECT_NAME/README.md << 'EOF'
# 🚀 Prueba Argo - NestJS con Argo Workflows

Aplicación NestJS con pipeline de CI/CD automático usando Argo Workflows y despliegue en Kubernetes.

## 📋 Características

- ✅ **NestJS** - Framework Node.js moderno
- ✅ **Docker** - Containerización optimizada multi-stage
- ✅ **Kubernetes** - Manifiestos listos para producción
- ✅ **Argo Workflows** - Pipeline CI/CD nativo de Kubernetes
- ✅ **GitHub Actions** - Integración automática
- ✅ **Health Checks** - Monitoreo de aplicación
- ✅ **Security** - Usuario no root, best practices

## 🏃‍♂️ Inicio Rápido

### 1. Desarrollo Local
```bash
# Instalar dependencias
npm install

# Desarrollo
npm run start:dev

# Tests
npm test

# Build
npm run build
```

### 2. Docker Local
```bash
# Build
docker build -t prueba-argo .

# Run
docker run -p 3000:3000 prueba-argo
```

### 3. Kubernetes + Argo
```bash
# Configurar todo automáticamente
./scripts/setup-complete.sh

# O despliegue manual
./scripts/deploy-manual.sh
```

## 🌐 Endpoints

- `GET /` - Mensaje de bienvenida
- `GET /health` - Estado de salud
- `GET /info` - Información de la aplicación

## 🔧 Configuración GitHub

En tu repositorio, ve a **Settings → Secrets and variables → Actions** y agrega:

```
ARGO_SERVER = http://localhost:2746
ARGO_TOKEN = <token-generado-por-setup-script>
```

## 📦 Estructura del Proyecto

```
prueba-argo/
├── src/                    # Código fuente NestJS
├── k8s/                    # Manifiestos Kubernetes
├── workflows/              # Definiciones Argo Workflows
├── scripts/               # Scripts de automatización
├── .github/workflows/     # GitHub Actions
└── Dockerfile             # Imagen Docker optimizada
```

## 🚀 Pipeline CI/CD

El pipeline se ejecuta automáticamente en cada push:

1. **Clone** - Descarga el código
2. **Test** - Ejecuta pruebas unitarias
3. **Build** - Construye imagen Docker
4. **Deploy** - Despliega en Kubernetes

## 🔍 Monitoreo

```bash
# Ver pods
kubectl get pods -n prueba-argo

# Ver logs
kubectl logs -l app=nestjs-app -n prueba-argo

# Port forward para probar
kubectl port-forward service/nestjs-service 8080:80 -n prueba-argo
```

## 👨‍💻 Autor

**Americo7** - [GitHub](https://github.com/Americo7)

---

🎉 **¡Disfruta tu aplicación NestJS con Argo Workflows!**
EOF

# Script de inicialización Git
cat > $PROJECT_NAME/scripts/init-git.sh << EOF
#!/bin/bash

echo "🔧 INICIALIZANDO REPOSITORIO GIT"
echo "==============================="

cd ../

# Inicializar Git si no existe
if [ ! -d ".git" ]; then
    echo "📦 Inicializando repositorio Git..."
    git init
    git branch -M main
else
    echo "✅ Repositorio Git ya existe"
fi

# Configurar usuario si no está configurado
if [ -z "\$(git config user.name)" ]; then
    echo "👤 Configurando usuario Git..."
    git config user.name "$GITHUB_USER"
    git config user.email "$DOCKER_USER@users.noreply.github.com"
fi

# Agregar archivos
echo "📁 Agregando archivos..."
git add .

# Commit inicial
echo "💾 Realizando commit inicial..."
git commit -m "🚀 Initial commit - NestJS app con Argo Workflows

✨ Features:
- NestJS application con TypeScript
- Docker multi-stage optimizado
- Kubernetes manifests
- Argo Workflows CI/CD pipeline
- GitHub Actions integration
- Health checks y monitoring
- Security best practices

🎯 Ready para despliegue automático!"

echo ""
echo "✅ Repositorio Git configurado"
echo ""
echo "📋 Próximos pasos:"
echo "1. Crear repositorio en GitHub: https://github.com/new"
echo "2. Ejecutar:"
echo "   git remote add origin https://github.com/$GITHUB_USER/$PROJECT_NAME.git"
echo "   git push -u origin main"
echo ""
echo "3. Ejecutar setup completo:"
echo "   ./scripts/setup-complete.sh"
EOF

chmod +x $PROJECT_NAME/scripts/init-git.sh

echo ""
echo "🎉 ¡PROYECTO CREADO EXITOSAMENTE!"
echo "================================"
echo ""
echo "📁 Estructura generada:"
echo "   $PROJECT_NAME/"
echo "   ├── src/                  # Código NestJS"
echo "   ├── k8s/                  # Kubernetes manifests"
echo "   ├── workflows/            # Argo Workflows"
echo "   ├── scripts/              # Scripts de automatización"
echo "   ├── .github/workflows/    # GitHub Actions"
echo "   └── Dockerfile            # Docker optimizado"
echo ""
echo "🚀 PASOS PARA EJECUTAR:"
echo ""
echo "1️⃣ Entrar al proyecto:"
echo "   cd $PROJECT_NAME"
echo ""
echo "2️⃣ Inicializar Git:"
echo "   ./scripts/init-git.sh"
echo ""
echo "3️⃣ Crear repo en GitHub:"
echo "   https://github.com/new"
echo "   Nombre: $PROJECT_NAME"
echo ""
echo "4️⃣ Conectar y subir:"
echo "   git remote add origin https://github.com/$GITHUB_USER/$PROJECT_NAME.git"
echo "   git push -u origin main"
echo ""
echo "5️⃣ Configurar Kubernetes y Argo:"
echo "   ./scripts/setup-complete.sh"
echo ""
echo "🔗 URLs importantes:"
echo "   • GitHub: https://github.com/$GITHUB_USER/$PROJECT_NAME"  
echo "   • Docker Hub: https://hub.docker.com/r/$DOCKER_USER/$PROJECT_NAME"
echo "   • Argo UI: $ARGO_SERVER"
echo ""
echo "✅ ¡Todo listo para usar!"
