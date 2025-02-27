fun urlEncode str =
  let
    fun charToHex c = "%" ^ (Int.fmt StringCvt.HEX (ord c))
    fun escapeChar c = if Char.isAlphaNum c then Char.toString c else charToHex c
  in
    String.concat (map escapeChar (explode str))
  end
