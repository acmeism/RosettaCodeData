object NonContinuousSubSequences extends App {

  private def seqR(s: String, c: String, i: Int, added: Int): Unit = {
    if (i == s.length) {
      if (c.trim.length > added) println(c)
    } else {
      seqR(s, c + s(i), i + 1, added + 1)
      seqR(s, c + " ", i + 1, added)
    }
  }

  seqR("1234", "", 0, 0)
}
