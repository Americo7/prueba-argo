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
