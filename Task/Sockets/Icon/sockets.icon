link cfunc
procedure main ()
   hello("localhost", 1024)
end

procedure hello (host, port)
   write(tconnect(host, port) | stop("unable to connect to", host, ":", port) ,  "hello socket world")
end
