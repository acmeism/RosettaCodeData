def reverse(s: String) = {
  import java.text.{Normalizer,BreakIterator}
  val norm = Normalizer.normalize(s, Normalizer.Form.NFKC) // waﬄe -> waffle (optional)
  val it = BreakIterator.getCharacterInstance
  it setText norm
  def break(it: BreakIterator, prev: Int, result: List[String] = Nil): List[String] = it.next match {
    case BreakIterator.DONE => result
    case cur => break(it, cur, norm.substring(prev, cur) :: result)
  }
  break(it, it.first).mkString
}
