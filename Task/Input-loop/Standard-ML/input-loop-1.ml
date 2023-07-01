fun foldLines f init strm =
  case TextIO.inputLine strm of
    SOME line => foldLines f (f (line, init)) strm
  | NONE => init
