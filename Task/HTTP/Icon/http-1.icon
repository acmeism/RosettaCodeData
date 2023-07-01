link cfunc
procedure main(arglist)
   get(arglist[1])
end

procedure get(url)
   local f, host, port, path
   url ? {
         ="http://" | ="HTTP://"
         host := tab(upto(':/') | 0)
         if not (=":" & (port := integer(tab(upto('/'))))) then port := 80
         if pos(0) then path := "/" else path := tab(0)
   }
   write(host)
   write(path)
   f := tconnect(host, port) | stop("Unable to connect")
   writes(f, "GET ", path | "/" ," HTTP/1.0\r\n\r\n")
   while write(read(f))
end
