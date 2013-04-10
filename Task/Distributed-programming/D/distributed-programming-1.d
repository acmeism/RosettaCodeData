module distributedserver ;
import tango.net.ServerSocket, tango.text.convert.Integer,
       tango.text.Util, tango.io.Stdout ;

void main() {
  auto Ip = new InternetAddress("localhost", 12345) ;
  auto server = new ServerSocket(Ip) ;
  auto socket = server.accept ;
  auto buffer = new char[socket.bufferSize] ;

  bool quit = false ;

  while(!quit) {
    bool error = false ;

    try {
      auto len = socket.input.read(buffer) ;
      auto cmd = (len > 0) ? delimit(buffer[0..len], " ") : [""] ;
      Stdout(cmd).newline.flush ;
      switch (cmd[0]) {
        case "square":
          socket.output.write(toString(toInt(cmd[1]) * toInt(cmd[1]))) ; break ;
        case"add":
          socket.output.write(toString(toInt(cmd[1]) + toInt(cmd[2]))) ; break ;
        case "quit":
          socket.output.write("Server Shut down") ;
          quit = true ; break ;
        default: error = true ;
      }
    } catch (Exception e)
      error = true ;
    if(error) socket.output.write("<Error>") ;
    if(socket) socket.close ;
    if(!quit) socket = server.accept ;
  }

  if(socket) socket.close ;
}
