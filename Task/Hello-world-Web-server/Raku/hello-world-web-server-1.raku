my $listen = IO::Socket::INET.new(:listen, :localhost<localhost>, :localport(8080));
loop {
    my $conn = $listen.accept;
    my $req =  $conn.get ;
    $conn.print: "HTTP/1.0 200 OK\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\nGoodbye, World!\r\n";
    $conn.close;
}
