fun copyLoop () =
  case TextIO.input TextIO.stdIn of
    "" => ()
  | tx => copyLoop (TextIO.output (TextIO.stdOut, tx))

val () = copyLoop ()
