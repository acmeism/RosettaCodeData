react {
    whenever IO::Socket::Async.listen('0.0.0.0', 12321) -> $conn {
        whenever $conn.Supply.lines -> $line {
            $conn.print( "$line\n" ) ;
        }
    }
}
