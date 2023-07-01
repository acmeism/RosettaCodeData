object SubstitutionCipher extends App {
  private val key = "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N" + "[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"
  private val text =
    """"It was still dark, in the early morning hours of the twenty-second of December
      | 1946, on the second floor of the house at Schilderskade 66 in our town,
      | when the hero of this story, Frits van Egters, awoke."""".stripMargin

  val enc = encode(text)
  println("Encoded: " + enc)
  println("Decoded: " + decode(enc))

  private def encode(s: String) = {
    val sb = new StringBuilder(s.length)
    s.map {
      case c if (' ' to '~').contains(c) => sb.append(key(c.toInt - 32))
      case _ =>
    }
    sb.toString
  }

  private def decode(s: String) = {
    val sb = new StringBuilder(s.length)
    s.map {
      case c if (' ' to '~').contains(c) =>
        sb.append((key.indexOf(c.toInt) + 32).toChar)
      case _ =>
    }
    sb.toString
  }
}
