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
