import scala.util.Random.shuffle
import scala.annotation.tailrec

  // ...

  def isBalanced(str: String): Boolean = isBalanced(str.toList, balance = 0)

  @tailrec
  def isBalanced(str: List[Char], balance: Int = 0): Boolean =
    str match {
      case _ if (balance < 0) => false
      case Nil => balance == 0
      case char :: rest =>
        val newBalance = char match {
          case '[' => balance + 1
          case ']' => balance -1
        }
        isBalanced(rest, newBalance)
    }
