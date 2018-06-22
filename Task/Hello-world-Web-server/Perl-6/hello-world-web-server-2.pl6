react {
    whenever IO::Socket::Async.listen('0.0.0.0', 8080) -> $conn {
        whenever $conn.Supply.lines -> $line {
            $conn.print: "HTTP/1.0 200 OK\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\nGoodbye, World!\r\n";
            $conn.close;
        }
    }
}
