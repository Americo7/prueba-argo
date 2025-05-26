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
if [ -z "$(git config user.name)" ]; then
    echo "👤 Configurando usuario Git..."
    git config user.name "Americo7"
    git config user.email "americo7@users.noreply.github.com"
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
echo "   git remote add origin https://github.com/Americo7/prueba-argo.git"
echo "   git push -u origin main"
echo ""
echo "3. Ejecutar setup completo:"
echo "   ./scripts/setup-complete.sh"
