import scala.util.control.Breaks._

object ShuntingYard {

  def main(args: Array[String]): Unit = {
    val infix = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
    println(s"infix:   $infix")
    println(s"postfix: ${infixToPostfix(infix)}")
  }

  def infixToPostfix(infix: String): String = {
    val ops = "-+/*^"
    val sb = new StringBuilder
    val s = scala.collection.mutable.Stack[Int]()

    infix.split("\\s").foreach { token =>
      if (token.nonEmpty) {
        val c = token.head
        val idx = ops.indexOf(c)

        if (idx != -1) {
          if (s.isEmpty) s.push(idx)
          else {
            breakable({
            while (s.nonEmpty) {
              val prec2 = s.top / 2
              val prec1 = idx / 2
              if (prec2 > prec1 || (prec2 == prec1 && c != '^')) sb.append(ops(s.pop)).append(' ')
              else break
            }
            });
            s.push(idx)
          }
        } else if (c == '(') {
          s.push(-2) // -2 stands for '('
        } else if (c == ')') {
          // until '(' on stack, pop operators.
          while (s.top != -2) sb.append(ops(s.pop)).append(' ')
          s.pop()
        } else {
          sb.append(token).append(' ')
        }
      }
    }
    while (s.nonEmpty) sb.append(ops(s.pop)).append(' ')
    sb.toString
  }
}
