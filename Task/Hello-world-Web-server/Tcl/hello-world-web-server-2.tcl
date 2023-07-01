set s [socket stream.server 127.0.0.1:8080]
$s readable {
    set client [$s accept]
    $client puts "HTTP/1.1 200 OK\nConnection: close\nContent-Type: text/plain\n"
    $client puts "Hello, World!\n"
    $client close
}
vwait done
