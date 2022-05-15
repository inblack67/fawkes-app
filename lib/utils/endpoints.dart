class Endpoints {
  static const base = 'localhost:4000/api';
  static const httpProtocol = 'http';
  static const rooms = '$httpProtocol://$base/rooms';
  static String getMessages(String roomId) =>
      '$httpProtocol://$base/rooms/$roomId/chat';
  static const websocket = 'ws://localhost:4000/socket/websocket';
}
