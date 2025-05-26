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
