import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHello(): string {
    return 'Hello World desde NestJS en K8s!';
  }

  @Get('health')
  getHealth(): object {
    return { status: 'OK', timestamp: new Date().toISOString() };
  }
}
