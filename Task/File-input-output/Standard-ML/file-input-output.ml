fun copyFile (from, to) =
let
  val instream = TextIO.openIn from
  val outstream = TextIO.openOut to
  val () = TextIO.output (outstream, TextIO.inputAll instream)
  val () = TextIO.closeIn instream
  val () = TextIO.closeOut outstream
in
  true
end handle _ => false;
