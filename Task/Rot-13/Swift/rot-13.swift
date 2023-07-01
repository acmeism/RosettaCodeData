func rot13char(c: UnicodeScalar) -> UnicodeScalar {
  switch c {
  case "A"..."M", "a"..."m":
    return UnicodeScalar(UInt32(c) + 13)
  case "N"..."Z", "n"..."z":
    return UnicodeScalar(UInt32(c) - 13)
  default:
    return c
  }
}

func rot13(str: String) -> String {
  return String(map(str.unicodeScalars){ c in Character(rot13char(c)) })
}

println(rot13("The quick brown fox jumps over the lazy dog"))
