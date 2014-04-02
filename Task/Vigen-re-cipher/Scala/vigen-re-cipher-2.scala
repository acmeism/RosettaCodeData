class Vigenere(val key: String) {

  private def rotate(p: Int, s: IndexedSeq[Char]) = s.drop(p) ++ s.take(p)

  private val chars = 'A' to 'Z'

  private val vSquare = (chars ++
                rotate(1, chars) ++
                rotate(2, chars) ++
                rotate(3, chars) ++
                rotate(4, chars) ++
                rotate(5, chars) ++
                rotate(6, chars) ++
                rotate(7, chars) ++
                rotate(8, chars) ++
                rotate(9, chars) ++
                rotate(10, chars) ++
                rotate(11, chars) ++
                rotate(12, chars) ++
                rotate(13, chars) ++
                rotate(14, chars) ++
                rotate(15, chars) ++
                rotate(16, chars) ++
                rotate(17, chars) ++
                rotate(18, chars) ++
                rotate(19, chars) ++
                rotate(20, chars) ++
                rotate(21, chars) ++
                rotate(22, chars) ++
                rotate(23, chars) ++
                rotate(24, chars) ++
                rotate(25, chars))

  private var encIndex = -1
  private var decIndex = -1

  def encode(c: Char) = {
    encIndex += 1
    if (encIndex == key.length) encIndex = 0
    if (chars.contains(c)) vSquare((c - 'A') * 26 + key(encIndex) - 'A') else c
  }

  def decode(c: Char) = {
    decIndex += 1
    if (decIndex == key.length) decIndex = 0
    if (chars.contains(c)) {
      val baseIndex = (key(decIndex) - 'A') * 26
      val nextIndex = vSquare.indexOf(c, baseIndex)
      chars(nextIndex - baseIndex)
    } else c
  }
}
