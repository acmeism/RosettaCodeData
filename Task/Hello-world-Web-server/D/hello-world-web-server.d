import std.socket, std.array;

ushort port = 8080;

void main() {
  Socket listener = new TcpSocket;
  listener.bind(new InternetAddress(port));
  listener.listen(10);

  Socket currSock;

  while (null !is (currSock = listener.accept())) {
    currSock.sendTo(replace(q"EOF
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

<html>
  <head><title>Hello world</title></head>
  <body>Goodbye, World!</body>
</html>
EOF", "\n", "\r\n"));
    currSock.close();
  }
}
