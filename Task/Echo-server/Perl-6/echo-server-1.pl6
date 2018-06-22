my $socket = IO::Socket::INET.new:
    :localhost<localhost>,
    :localport<12321>,
    :listen;

while $socket.accept -> $conn {
    say "Accepted connection";
    start {
        while $conn.recv -> $stuff {
            say "Echoing $stuff";
            $conn.print($stuff);
        }
        $conn.close;
    }
}
