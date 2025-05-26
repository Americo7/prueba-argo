#!/bin/bash

echo "🚀 CONFIGURACIÓN AUTOMÁTICA PARA Americo7"
echo "=================================="
echo "📦 Proyecto: prueba-argo"
echo "🐳 Registry: docker.io/americo7"
echo "⚙️  Argo Server: http://localhost:2746"
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
    read -s -p "🔑 Password de Docker Hub para usuario 'americo7': " DOCKER_PASSWORD
    echo
    
    if [[ -n "$DOCKER_PASSWORD" ]]; then
        break
    else
        echo "❌ Password no puede estar vacío"
    fi
done

# Crear o actualizar el secreto
kubectl create secret docker-registry docker-config \
  --docker-server=docker.io \
  --docker-username=americo7 \
  --docker-password="$DOCKER_PASSWORD" \
  --docker-email=americo7@email.com \
  -n argo --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Secreto de Docker configurado"

# Crear ServiceAccount
echo "👤 Configurando ServiceAccount..."
kubectl create serviceaccount argo-workflow -n argo --dry-run=client -o yaml | kubectl apply -f -

# Crear ClusterRoleBinding
echo "🔑 Configurando permisos..."
kubectl create clusterrolebinding argo-workflow-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=argo:argo-workflow \
  --dry-run=client -o yaml | kubectl apply -f -

# Generar token de larga duración
echo "🎫 Generando token de acceso..."
TOKEN=$(kubectl create token argo-workflow -n argo --duration=8760h)

if [[ -z "$TOKEN" ]]; then
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
echo "1️⃣  Agregar secrets en GitHub (Americo7/prueba-argo):"
echo "   Ve a: Settings → Secrets and variables → Actions"
echo ""
echo "   🔑 ARGO_SERVER = http://localhost:2746"
echo "   🔑 ARGO_TOKEN = $TOKEN"
echo ""
echo "2️⃣  Hacer push del código:"
echo "   cd prueba-argo"
echo "   git add ."
echo "   git commit -m '🚀 Initial commit - NestJS app con Argo Workflows'"
echo "   git push origin main"
echo ""
echo "3️⃣  El pipeline se ejecutará automáticamente al hacer push!"
echo ""
echo "4️⃣  Para probar la app desplegada:"
echo "   kubectl port-forward service/nestjs-service 8080:80 -n prueba-argo"
echo "   curl http://localhost:8080"
echo ""
echo "🔗 URLs útiles:"
echo "   • Argo UI: http://localhost:2746"
echo "   • GitHub: https://github.com/Americo7/prueba-argo"
echo "   • Docker Hub: https://hub.docker.com/r/americo7/prueba-argo"
echo ""
echo "✅ ¡Todo listo para usar!"

# Guardar token en archivo para referencia
echo "$TOKEN" > ../argo-token.txt
echo "💾 Token guardado en: ../argo-token.txt"
