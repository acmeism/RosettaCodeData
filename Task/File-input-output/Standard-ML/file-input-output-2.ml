fun copyFile from to =
let
  val instream = BinIO.openIn from
  val outstream = BinIO.openOut to
  fun aux () =
    let
      val buf = BinIO.inputN(instream, 1024)
    in
      if Word8Vector.length buf = 0
      then ()
      else (BinIO.output (outstream, buf); aux ())
    end
in
  (aux (); BinIO.closeIn instream; BinIO.closeOut outstream)
end
