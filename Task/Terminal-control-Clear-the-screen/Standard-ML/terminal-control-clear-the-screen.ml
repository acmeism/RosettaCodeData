fun clearScreen () =
  let
    val strm = TextIO.openOut (Posix.ProcEnv.ctermid ())
  in
    TextIO.output (strm, "\^[[H\^[[2J");
    TextIO.closeOut strm
  end
