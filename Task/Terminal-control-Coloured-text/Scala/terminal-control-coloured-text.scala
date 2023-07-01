object ColouredText extends App {
  val ESC = "\u001B"
  val (normal, bold, blink, black, white) =
    (ESC + "[0", ESC + "[1"
      , ESC + "[5" // not working on my machine
      , ESC + "[0;40m" // black background
      , ESC + "[0;37m" // normal white foreground
    )

  print(s"${ESC}c") // clear terminal first
  print(black) // set background color to black
  def foreColors = Map(
    ";31m" -> "red",
    ";32m" -> "green",
    ";33m" -> "yellow",
    ";34m" -> "blue",
    ";35m" -> "magenta",
    ";36m" -> "cyan",
    ";37m" -> "white")

  Seq(normal, bold, blink).flatMap(attr => foreColors.map(color => (attr, color)))
    .foreach { case (attr, (seq, text)) => println(s"$attr${seq}${text}") }
  println(white) // set foreground color to normal white
}
