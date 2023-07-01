module socket ;
import std.stdio ;
import std.socket ;
version(Win32) {
  // For Win32 systems, need to link with ws2_32.lib.
  pragma(lib, "ws2_32.lib") ;
}
void main() {
  long res;
  auto socket = new Socket(AddressFamily.INET, SocketType.STREAM) ;
  socket.connect(new InternetAddress("localhost",256)) ;
  res = socket.send(cast(void[])"hello socket world") ;
  writefln("Socket %d bytes sent.", res) ;
  socket.close() ;
}
