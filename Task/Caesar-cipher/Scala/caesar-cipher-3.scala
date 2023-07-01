class Caeser(val key: Int) {
  @annotation.tailrec
  private def rotate(p: Int, s: IndexedSeq[Char]): IndexedSeq[Char] = if (p < 0) rotate(s.length + p, s) else s.drop(p) ++ s.take(p)

  val uc = 'A' to 'Z'
  val lc = 'a' to 'z'
  val as = uc ++ lc
  val bs = rotate(key, uc) ++ rotate(key, lc)

  def encode(c: Char) = if (as.contains(c)) bs(as.indexOf(c)) else c
  def decode(c: Char) = if (bs.contains(c)) as(bs.indexOf(c)) else c
}
