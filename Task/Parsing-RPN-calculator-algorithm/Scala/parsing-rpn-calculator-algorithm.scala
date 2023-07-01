object RPN {
  val PRINT_STACK_CONTENTS: Boolean = true

  def main(args: Array[String]): Unit = {
    val result = evaluate("3 4 2 * 1 5 - 2 3 ^ ^ / +".split(" ").toList)
    println("Answer: " + result)
  }

  def evaluate(tokens: List[String]): Double = {
    import scala.collection.mutable.Stack
    val stack: Stack[Double] = new Stack[Double]
    for (token <- tokens) {
      if (isOperator(token)) token match {
        case "+" => stack.push(stack.pop + stack.pop)
        case "-" => val x = stack.pop; stack.push(stack.pop - x)
        case "*" => stack.push(stack.pop * stack.pop)
        case "/" => val x = stack.pop; stack.push(stack.pop / x)
        case "^" => val x = stack.pop; stack.push(math.pow(stack.pop, x))
        case _ => throw new RuntimeException( s""""$token" is not an operator""")
      }
      else stack.push(token.toDouble)

      if (PRINT_STACK_CONTENTS) {
        print("Input: " + token)
        print(" Stack: ")
        for (element <- stack.seq.reverse) print(element + " ");
        println("")
      }
    }

    stack.pop
  }

  def isOperator(token: String): Boolean = {
    token match {
      case "+" => true; case "-" => true; case "*" => true; case "/" => true; case "^" => true
      case _ => false
    }
  }
}
