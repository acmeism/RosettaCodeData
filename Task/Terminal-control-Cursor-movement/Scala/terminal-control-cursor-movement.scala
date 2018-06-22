object CursorMovement extends App {
  val ESC = "\u001B" // escape code

  print(s"$ESC[2J$ESC[10;10H") // clear terminal first, move cursor to (10, 10) say
  val aecs = Seq(
    "[1D", // left
    "[1C", // right
    "[1A", // up
    "[1B", // down
    "[9D", // line start
    "[H", // top left
    "[24;79H" // bottom right - assuming 80 x 24 terminal
  )
  for (aec <- aecs) {
    Thread.sleep(3000) // three second display between cursor movements
    print(s"$ESC$aec")
  }

}
