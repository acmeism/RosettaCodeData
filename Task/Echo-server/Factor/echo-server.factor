USING: accessors io io.encodings.utf8 io.servers io.sockets threads ;
IN: rosetta.echo

CONSTANT: echo-port 12321

: handle-client ( -- )
   [ print flush ] each-line ;

: <echo-server> ( -- threaded-server )
    utf8 <threaded-server>
        "echo server" >>name
        echo-port >>insecure
        [ handle-client ] >>handler ;

: start-echo-server ( -- )
    <echo-server> [ start-server ] in-thread start-server drop ;
