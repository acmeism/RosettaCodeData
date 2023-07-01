import 'dart:io';

main() async {
  var server = await HttpServer.bind('127.0.0.1', 8080);

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, world')
      ..close();
  }
}
