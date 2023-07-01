fun sysRand32 () =
  let
    val strm = BinIO.openIn "/dev/urandom"
  in
    PackWord32Big.subVec (BinIO.inputN (strm, 4), 0) before BinIO.closeIn strm
  end

val () = print (LargeWord.fmt StringCvt.DEC (sysRand32 ()) ^ "\n")
