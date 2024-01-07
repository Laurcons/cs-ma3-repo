import { PrismaClientKnownRequestError } from '@prisma/client/runtime/library';
import { Error } from './errors';

export async function handlePrismaVersionError(
  callback: () => Promise<unknown>,
) {
  try {
    return await callback();
  } catch (err: any) {
    if (err instanceof PrismaClientKnownRequestError) {
      if (err.code === 'P2025') {
        throw Error.EntityNotFoundOrVersion;
      }
    }
    throw err;
  }
}
