import { HttpException, HttpStatus } from '@nestjs/common';

export const Error = {
  EntityNotFoundOrVersion: new HttpException(
    'The train number + version combination was not found on the server. Either the train number does not exist, or someone updated the entity when you were offline. Please try again.',
    422,
  ),
};
