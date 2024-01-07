import { Injectable } from '@nestjs/common';
import PrismaService from './prisma.service';
import { TripLeg } from '@prisma/client';
import { handlePrismaVersionError } from './lib/util/prisma-errors';
import { Subject } from 'rxjs';

@Injectable()
export class TripLegService {
  private opStreamSub = new Subject<
    | {
        op: 'create';
        data: Partial<TripLeg>;
      }
    | {
        op: 'update';
        id: string;
        data: Partial<TripLeg>;
      }
    | {
        op: 'delete';
        id: string;
      }
  >();
  public opStream$ = this.opStreamSub.asObservable();

  constructor(private prisma: PrismaService) {}

  async findAll() {
    return await this.prisma.tripLeg.findMany();
  }

  async create(leg: TripLeg) {
    const created = await this.prisma.tripLeg.create({ data: leg });
    this.opStreamSub.next({
      op: 'create',
      data: created,
    });
    return created;
  }

  async update(trainNum: string, v: number, newLeg: Partial<TripLeg>) {
    return handlePrismaVersionError(async () => {
      const leg = await this.prisma.tripLeg.update({
        where: {
          v,
          trainNum,
        },
        data: {
          ...newLeg,
          v: v + 1,
        },
      });
      this.opStreamSub.next({
        op: 'update',
        id: trainNum,
        data: leg,
      });
      return leg;
    });
  }

  async delete(trainNum: string, v: number) {
    return handlePrismaVersionError(async () => {
      const leg = await this.prisma.tripLeg.delete({
        where: { trainNum, v },
      });
      this.opStreamSub.next({
        op: 'delete',
        id: trainNum,
      });
      return leg;
    });
  }
}
