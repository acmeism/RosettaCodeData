object Main extends App {

  val raining = true
  val needUmbrella = raining
  println(s"Do I need an umbrella?  ${if (needUmbrella) "Yes" else "No"}")
}
