use v6;

my $socket = IO::Socket::INET.new(host => "www.rosettacode.org",
				  port => 80,);
$socket.print("GET / HTTP/1.0\r\n\r\n");
print $socket.recv();
$socket.close;
