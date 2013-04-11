my $sock = IO::Socket::INET.new(:localhost('0.0.0.0'), :localport(8080), :listen);
say "Goodbye Web Server listening on $sock.localhost():$sock.localport()";
while $sock.accept -> $client {
    $client.send: "HTTP/1.0 200 OK\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\nGoodbye, World!\r\n";
    $client.close;
}
