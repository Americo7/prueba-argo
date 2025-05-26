#!/bin/bash

echo "🚀 DESPLIEGUE MANUAL RÁPIDO"
echo "========================="

IMAGE_TAG=${1:-latest}
echo "🏷️ Usando imagen: docker.io/americo7/prueba-argo:$IMAGE_TAG"

# Aplicar manifiestos
echo "📦 Aplicando namespace..."
kubectl apply -f ../k8s/namespace.yaml

echo "⚙️ Aplicando configuración..."
kubectl apply -f ../k8s/configmap.yaml

echo "🔄 Configurando imagen en deployment..."
sed "s|__IMAGE_TAG__|docker.io/americo7/prueba-argo:$IMAGE_TAG|g" ../k8s/deployment.yaml | kubectl apply -f -

echo "🌐 Aplicando service..."
kubectl apply -f ../k8s/service.yaml

echo "⏳ Esperando deployment..."
kubectl rollout status deployment/nestjs-app -n prueba-argo --timeout=300s

echo "📊 Estado:"
kubectl get pods,svc -n prueba-argo

echo "✅ ¡Listo! Para probar:"
echo "kubectl port-forward service/nestjs-service 8080:80 -n prueba-argo"
