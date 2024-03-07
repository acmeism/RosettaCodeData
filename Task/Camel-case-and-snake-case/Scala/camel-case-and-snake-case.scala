object CamelCaseAndSnakeCase extends App {

  val variableNames = List("snakeCase", "snake_case", "variable_10_case", "variable10Case",
    "ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  ")

  println(" " * 26 + "=== To snake_case ===")
  variableNames.foreach { text =>
    println(f"$text%34s --> ${toSnakeCase(text)}")
  }

  println("\n" + " " * 26 + "=== To camelCase ===")
  variableNames.foreach { text =>
    println(f"$text%34s --> ${toCamelCase(text)}")
  }

  def toSnakeCase(camel: String): String = {
    val snake = new StringBuilder
    camel.trim.replace(" ", "_").replace("-", "_").foreach { ch =>
      if (snake.isEmpty || snake.last != '_' || ch != '_') {
        if (ch.isUpper && snake.nonEmpty && snake.last != '_') snake.append('_')
        snake.append(ch.toLower)
      }
    }
    snake.toString
  }

  def toCamelCase(snake: String): String = {
    val camel = new StringBuilder
    var underscore = false
    snake.trim.replace(" ", "_").replace("-", "_").foreach { ch =>
      if (ch == '_') underscore = true
      else if (underscore) {
        camel.append(ch.toUpper)
        underscore = false
      } else camel.append(ch)
    }
    camel.toString
  }
}
