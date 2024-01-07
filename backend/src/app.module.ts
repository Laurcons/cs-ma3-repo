import { Module } from '@nestjs/common';
import { TripLegController } from './trip-leg.controller';
import { TripLegService } from './trip-leg.service';
import PrismaService from './prisma.service';
import { TripLegGateway } from './trip-leg.gateway';

@Module({
  imports: [],
  controllers: [TripLegController],
  providers: [TripLegService, PrismaService, TripLegGateway],
})
export class AppModule {}
