import { OnGatewayConnection, WebSocketGateway } from '@nestjs/websockets';
import { Socket } from 'socket.io';
import { TripLegService } from './trip-leg.service';
import { Logger } from '@nestjs/common';

@WebSocketGateway({
  // transports: ['websocket'],
  // namespace: '/fuck',
  path: '/I-AM-HAVING-A-HORRIBLE-TIME',
  cors: {
    origin: '*',
  },
})
export class TripLegGateway implements OnGatewayConnection {
  constructor(private tripLegService: TripLegService) {}

  handleConnection(client: Socket, ...args: any[]) {
    Logger.log('WS Connected');
    this.tripLegService.opStream$.subscribe((op) => {
      client.emit('operation', op);
    });
  }
}
