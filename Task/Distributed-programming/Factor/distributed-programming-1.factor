USING: concurrency.distributed concurrency.messaging threads io.sockets io.servers ;
QUALIFIED: concurrency.messaging
: prettyprint-message ( -- ) concurrency.messaging:receive . flush prettyprint-message ;
[ prettyprint-message ] "logger" spawn dup name>> register-remote-thread
"127.0.0.1" 9000 <inet4> <node-server> start-server
