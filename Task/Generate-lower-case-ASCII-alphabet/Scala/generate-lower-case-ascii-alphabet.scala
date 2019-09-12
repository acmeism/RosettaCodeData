object Abc extends App {
  val lowAlpha = 'a' to 'z' //That's all
  // Now several tests
  assert(lowAlpha.toSeq == Seq('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'),
    "No complete lowercase alphabet.")
  assert(lowAlpha.size == 26, "No 26 characters in alphabet")
  assert(lowAlpha.start == 'a', "Character 'a' not first char! ???")
  assert(lowAlpha.head == 'a', "Character 'a' not heading! ???")
  assert(lowAlpha.head == lowAlpha(0), "Heading char is not first char.")
  assert(lowAlpha contains 'n', "Character n not present.")
  assert(lowAlpha.indexOf('n') == 13, "Character n not on the 14th position.")
  assert(lowAlpha.last == lowAlpha(25), "Expected character (z)on the last and 26th pos.")

  println(s"Successfully completed without errors. [within ${
    scala.compat.Platform.currentTime - executionStart
  } ms]")
}
