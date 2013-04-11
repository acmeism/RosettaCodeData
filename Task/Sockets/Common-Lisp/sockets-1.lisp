CL-USER> (usocket:with-client-socket (socket stream "localhost" 256)
           (write-line "hello socket world" stream)
           (values))
; No value
