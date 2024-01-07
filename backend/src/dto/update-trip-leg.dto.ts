import { PartialType } from '@nestjs/swagger';
import { CreateTripLegDto } from './create-trip-leg.dto';
import { IsInt } from 'class-validator';

export class UpdateTripLegDto extends PartialType(CreateTripLegDto) {}
