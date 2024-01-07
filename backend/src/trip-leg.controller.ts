import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { TripLegService } from './trip-leg.service';
import { CreateTripLegDto } from './dto/create-trip-leg.dto';
import { UpdateTripLegDto } from './dto/update-trip-leg.dto';
import { VersionQueryDto } from './dto/version-query.dto';

@Controller('/trip-leg')
export class TripLegController {
  constructor(private readonly tripLegService: TripLegService) {}

  @Get('/')
  async all() {
    return await this.tripLegService.findAll();
  }

  @Post('/')
  async create(@Body() body: CreateTripLegDto) {
    return await this.tripLegService.create(body);
  }

  @Patch('/:num')
  async patch(
    @Body() body: UpdateTripLegDto,
    @Param('num') trainNum: string,
    @Query() { v }: VersionQueryDto,
  ) {
    return await this.tripLegService.update(trainNum, v, body);
  }

  @Delete('/:num')
  async delete(
    @Param('num') trainNum: string,
    @Query() { v }: VersionQueryDto,
  ) {
    return await this.tripLegService.delete(trainNum, v);
  }
}
