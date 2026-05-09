import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  static late IO.Socket socket;
  
  // Replace this with your actual IPv4 address!
  static const String baseUrl = 'http://192.168.1.165:5000'; 

  static void connect() {
    print('🔌 FLUTTER: Initializing Socket.io...');

    socket = IO.io(baseUrl, IO.OptionBuilder()
      .setTransports(['websocket']) // Force WebSockets
      .disableAutoConnect() // We connect manually below
      .build()
    );


    socket.onConnect((_) {
      print('🟢 FLUTTER: Connected to WebSockets successfully!');
    });

    socket.onConnectError((err) {
      print('🔴 FLUTTER: Connection Error -> $err');
    });

    socket.onError((err) {
      print('🔴 FLUTTER: General Error -> $err');
    });

    socket.on('new_alert', (data) {
      print('🚨 REAL-TIME ALERT RECEIVED: $data');
    });

    socket.onDisconnect((_) => print('🔴 FLUTTER: Disconnected'));
    socket.connect();
  }
}