use Socket;

my $port = 8080;
my $protocol = getprotobyname( "tcp" );

socket( SOCK, PF_INET, SOCK_STREAM, $protocol ) or die "couldn't open a socket: $!";
  # PF_INET to indicate that this socket will connect to the internet domain
  # SOCK_STREAM indicates a TCP stream, SOCK_DGRAM would indicate UDP communication

setsockopt( SOCK, SOL_SOCKET, SO_REUSEADDR, 1 ) or die "couldn't set socket options: $!";
  # SOL_SOCKET to indicate that we are setting an option on the socket instead of the protocol
  # mark the socket reusable

bind( SOCK, sockaddr_in($port, INADDR_ANY) ) or die "couldn't bind socket to port $port: $!";
  # bind our socket to $port, allowing any IP to connect

listen( SOCK, SOMAXCONN ) or die "couldn't listen to port $port: $!";
  # start listening for incoming connections

while( accept(CLIENT, SOCK) ){
  print CLIENT "HTTP/1.1 200 OK\r\n" .
               "Content-Type: text/html; charset=UTF-8\r\n\r\n" .
               "<html><head><title>Goodbye, world!</title></head><body>Goodbye, world!</body></html>\r\n";
  close CLIENT;
}
