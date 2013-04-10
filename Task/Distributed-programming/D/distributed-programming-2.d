module distributedclient ;
import tango.net.SocketConduit, tango.net.InternetAddress,
       tango.text.Util, tango.io.Stdout ;

void main(char[][] args) {

  if(args.length> 1) {
    try {
      auto Ip = new InternetAddress("localhost", 12345) ;
      auto socket = new SocketConduit ;
      socket.connect(Ip) ;
      auto buffer = new char[socket.bufferSize] ;

      socket.output.write(join(args[1..$]," ")) ;
      auto len = socket.input.read(buffer) ;
      if(len > 0) Stdout(buffer[0..len]).newline ;

      if(socket) socket.close ;
    } catch(Exception e)
      Stdout(e.msg).newline ;
  } else
    Stdout("usage: supply argument as,\n\tquit\n"
      "\tsquare <number>\n\tadd <number> <number>").newline ;
}
