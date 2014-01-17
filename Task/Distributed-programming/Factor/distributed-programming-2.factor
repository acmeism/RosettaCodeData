USING: concurrency.distributed io.sockets ;
QUALIFIED: concurrency.messaging
{ "Hello Remote Factor!" H{ { "key1" "value1" } } }
"127.0.0.1" 9000 <inet4> "logger" <remote-thread> concurrency.messaging:send
