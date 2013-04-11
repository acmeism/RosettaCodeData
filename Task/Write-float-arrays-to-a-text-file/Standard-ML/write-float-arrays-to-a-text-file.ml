fun writeDat (filename, x, y, xprec, yprec) = let
  val os = TextIO.openOut filename
  fun write_line (a, b) =
    TextIO.output (os, Real.fmt (StringCvt.GEN (SOME xprec)) a ^ "\t" ^
                       Real.fmt (StringCvt.GEN (SOME yprec)) b ^ "\n")
in
  ListPair.appEq write_line (x, y);
  TextIO.closeOut os
end;
