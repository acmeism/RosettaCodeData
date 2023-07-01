BEGIN
   STRING printer name = "/dev/lp0";
   FILE line printer;
   IF open (line printer, printer name, stand out channel) = 0 THEN
      put (line printer, ("Hello world", newline));
      close (line printer)
   ELSE
      put (stand error, ("Can't contact line printer on ", printer name, newline));
      put (stand error, ("Trying to use lpr(1)", newline));
      PIPE printer pipe = execve child pipe ("lpr", "", "");
      IF pid OF printer pipe < 0 THEN
	 put (stand error, ("Oh dear, that didn't seem to work either.  Giving up.", newline));
	 stop
      FI;
      put (write OF printer pipe, ("Hello world", newline));
      close (read OF printer pipe);
      close (write OF printer pipe)
   FI
END
