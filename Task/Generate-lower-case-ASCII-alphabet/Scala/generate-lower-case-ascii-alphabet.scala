object Abc extends App {
  val lowAlfa = 'a' to 'z' //That's all
  // Now several tests
  assert(lowAlfa.toSeq == Seq('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'),
    "No complete lowercase alfabet.")
  assert(lowAlfa.size == 26, "No 26 characters in alfabet")
  assert(lowAlfa.start == 'a', "Character 'a' not first char! ???")
  assert(lowAlfa.head == 'a', "Character 'a' not heading! ???")
  assert(lowAlfa.head == lowAlfa(0), "Heading char is not first char.")
  assert(lowAlfa contains 'n', "Character n not present.")
  assert(lowAlfa.indexOf('n') == 13, "Character n not on the 14th position.")
  assert(lowAlfa.last == lowAlfa(25), "Expected character (z)on the last and 26th pos.")

  println(s"Successfully completed without errors. [within ${
    scala.compat.Platform.currentTime - executionStart
  } ms]")
}
