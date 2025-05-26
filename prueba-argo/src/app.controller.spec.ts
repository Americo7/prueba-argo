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
