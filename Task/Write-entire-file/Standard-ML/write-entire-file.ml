fun writeFile (path, str) =
  (fn strm =>
    TextIO.output (strm, str) before TextIO.closeOut strm) (TextIO.openOut path)
