fun rot13stdin () =
  case (TextIO.inputLine TextIO.stdIn)
    of NONE => ()
    |  SOME(s) => (print (rot13 s); rot13stdin ());
