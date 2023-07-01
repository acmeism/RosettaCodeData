use IO::Socket::INET;

my $sock = new IO::Socket::INET ( LocalAddr => "127.0.0.1:8080",
                                  Listen    => 1,
                                  Reuse     => 1, ) or die "Could not create socket: $!";

while( my $client = $sock->accept() ){
  print $client "HTTP/1.1 200 OK\r\n" .
                "Content-Type: text/html; charset=UTF-8\r\n\r\n" .
                "<html><head><title>Goodbye, world!</title></head><body>Goodbye, world!</body></html>\r\n";
  close $client;
}
