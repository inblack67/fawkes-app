class Endpoints {
  static const host = 'localhost:4000';
  static const base = '$host/api';
  static const httpProtocol = 'http';
  static const websocketProtocol = 'ws';
  static const rooms = '$httpProtocol://$base/rooms';
  static const websocket = '$websocketProtocol://$host/socket/websocket';
}
