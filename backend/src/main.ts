import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger, ValidationPipe } from '@nestjs/common';
import { Request, Response } from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  app.use((req: Request, res: Response, next) => {
    res.on('finish', () => {
      Logger.log(
        `${req.method} ${req.url} ${res.statusCode} ${
          res.getHeader('content-length') ?? 0
        }b`,
      );
    });
    next();
  });

  await app.listen(parseInt(process.env.PORT));
}
bootstrap();
