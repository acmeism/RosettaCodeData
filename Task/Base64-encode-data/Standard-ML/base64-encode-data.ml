fun b64enc filename =
  let
    val instream = BinIO.openIn filename
    val data = BinIO.inputAll instream
  in
    Base64.encode data before BinIO.closeIn instream
  end
