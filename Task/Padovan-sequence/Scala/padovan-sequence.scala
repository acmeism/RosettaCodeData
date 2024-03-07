object Padovan extends App {

  val recurrences = new collection.mutable.ListBuffer[Int]()
  val floors = new collection.mutable.ListBuffer[Int]()
  val PP = 1.324717957244746025960908854
  val SS = 1.0453567932525329623

  for (i <- 0 until 64) {
    recurrences += padovanRecurrence(i)
    floors += padovanFloor(i)
  }

  println("The first 20 terms of the Padovan sequence:")
  recurrences.slice(0, 20).foreach(term => print(s"${term} "))
  println("\n")

  println(s"Recurrence and floor functions agree for first 64 terms? ${recurrences == floors}")
  println("")

  val words = createLSystem()

  println("The first 10 terms of the L-system:")
  words.slice(0, 10).foreach(term => print(term + " "))
  println("\n")

  print("Length of first 32 terms produced from the L-system match Padovan sequence? ")
  val wordLengths = words.map(_.length)
  print(wordLengths.slice(0, 32) == recurrences.slice(0, 32))

  def padovanRecurrence(n: Int): Int = {
    if (n <= 2) 1 else recurrences(n - 2) + recurrences(n - 3)
  }

  def padovanFloor(aN: Int): Int = {
    scala.math.floor(scala.math.pow(PP, aN - 1) / SS + 0.5).toInt
  }

  def createLSystem(): List[String] = {
    var words = List("A")
    var text = "A"

    while (words.length < 32) {
      text = text.flatMap {
        case 'A' => "B"
        case 'B' => "C"
        case 'C' => "AB"
      }
      words = words :+ text
    }

    words
  }

}
