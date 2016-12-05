object Vigenere {

  val key = "LEMON"
  val chars = 'A' to 'Z'

  private def rotate(p: Int, s: IndexedSeq[Char]) = s.drop(p) ++ s.take(p)
  val vSquare = (for (i <- Range(0, 25)) yield rotate(i, chars)).flatten

  def encrypt(s: String) = enrOrDecode(0, s.toUpperCase, encode)
  def decrypt(s: String) = enrOrDecode(0, s.toUpperCase, decode)

  private def enrOrDecode(i: Int , in: String, op:(Char, Int) => Char): String = {
    if (in.length == 0) in else {
      val index = if (i == key.length) 0 else i
      (if (chars.contains(in.head)) op(in.head, index) else in.head) + enrOrDecode(index + 1, in.tail, op)
    }
  }

  private def encode(c: Char, index: Int): Char = {
    vSquare((c - 'A') * 26 + key(index) - 'A')
  }

  private def decode(c: Char, index: Int) = {
      val baseIndex = (key(index) - 'A') * 26
      val nextIndex = vSquare.indexOf(c, baseIndex)
      chars(nextIndex - baseIndex)
  }
}
