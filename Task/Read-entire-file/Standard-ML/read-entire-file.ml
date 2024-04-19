(* string -> string *)
fun readFile path =
  (fn strm =>
    TextIO.inputAll strm before TextIO.closeIn strm) (TextIO.openIn path)
