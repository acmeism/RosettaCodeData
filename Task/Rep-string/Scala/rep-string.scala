object RepString extends App {
  def repsOf(s: String) = s.trim match {
    case s if s.length < 2 => Nil
    case s => (1 to (s.length/2)).map(s take _)
        .filter(_ * s.length take s.length equals s)
  }

  val tests = Array(
    "1001110011",
    "1110111011",
    "0010010010",
    "1010101010",
    "1111111111",
    "0100101101",
    "0100100",
    "101",
    "11",
    "00",
    "1"
  )
  def printReps(s: String) = repsOf(s) match {
    case Nil => s+": NO"
    case r => s+": YES ("+r.mkString(", ")+")"
  }
  val todo = if (args.length > 0) args else tests
  todo.map(printReps).foreach(println)
}
