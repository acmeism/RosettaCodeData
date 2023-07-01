procedure main(arglist)       #: usage socket port hostname or socket port
    hello(arglist[2]|"",arglist[1])
end

procedure hello(host,port)
   local s
   /host := ""
   host ||:= ":"
   host ||:= 0 < 65536 > port | runerr(103,port)
   if s := open(host,"n") then {
      write(s, "hello socket world.")
      close(s)
      }
   else  stop("Unable to connect to ",host,":",port)
   return
end
