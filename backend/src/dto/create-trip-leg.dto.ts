import { IsOptional, IsString } from 'class-validator';

export class CreateTripLegDto {
  @IsString()
  trainNum: string;

  @IsString()
  depStation: string;

  @IsString()
  arrStation: string;

  @IsString()
  depTime: string;

  @IsString()
  arrTime: string;

  @IsString()
  @IsOptional()
  observations: string = '';

  v = null;
}
