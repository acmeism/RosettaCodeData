import scala.util.Random.shuffle

object BalancedBracketsApp extends App {

  for (length <- 0 until 10) {
    val str = randomBrackets(length)
    if (is_balanced(str))
      println(s"$str - ok")
    else
      println(s"$str - NOT ok")
  }

  def randomBrackets(length: Int): String =
    shuffle(("[]" * length).toSeq).mkString

  def isBalanced(bracketString: String): Boolean = {
    var balance = 0
    for (char <- bracketString) {
      char match {
        case '[' => balance += 1
        case ']' => balance -= 1
      }
      if (balance < 0) return false;
    }
    balance == 0
  }

}
