def thueMorse(n: Int): String = {
  val (sb0, sb1) = (new StringBuilder("0"), new StringBuilder("1"))
  (0 until n).foreach { _ =>
    val tmp = sb0.toString()
    sb0.append(sb1)
    sb1.append(tmp)
  }
  sb0.toString()
}

(0 to 6).foreach(i => println(s"$i : ${thueMorse(i)}"))
