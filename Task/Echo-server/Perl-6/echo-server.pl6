my $socket = IO::Socket::INET.new:
    localhost => 'localhost',
    localport => 12321,
    listen    => 1;

while $socket.accept -> $conn {
    say "Accepted connection";
    async {
        while $conn.recv -> $stuff {
            say "Echoing $stuff";
            $conn.send($stuff);
        }
        $conn.close;
    }
}
