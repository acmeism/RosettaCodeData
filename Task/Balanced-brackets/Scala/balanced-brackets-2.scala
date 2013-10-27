import scala.util.Random

object BalancedParensApp extends App {

  val triesCount = 10

  (0 until triesCount).foreach { i =>
    val str = randomString(length = i)
    val msg = if (isBalanced(str)) "ok" else "NOT ok"
    println(s"$str - $msg")
  }

  def randomString(length: Int) = {
    val parensPairs = ("[]" * length).toSeq
    val parensOfGivenLength = parensPairs.take(length)
    val shuffledParens = Random.shuffle(parensOfGivenLength)
    shuffledParens.mkString
  }

  def isBalanced(parensString: String): Boolean = {
    var balance = 0
    parensString.foreach { char =>
      char match {
        case '[' => balance += 1
        case ']' => balance -= 1
      }
      if (balance < 0) return false;
    }
    balance == 0
  }

}
