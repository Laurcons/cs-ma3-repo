import { IsInt } from 'class-validator';
import { Transform } from 'class-transformer';

export class VersionQueryDto {
  @IsInt()
  @Transform((from) => parseInt(from.value))
  v: number;
}
