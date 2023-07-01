object MadLibs extends App{
  val input = "<name> went for a walk in the park. <he or she>\nfound a <noun>. <name> decided to take it home."
  println(input)
  println

  val todo = "(<[^>]+>)".r
  val replacements = todo.findAllIn(input).toSet.map{found: String =>
    found -> readLine(s"Enter a $found ")
  }.toMap

  val output = todo.replaceAllIn(input, found => replacements(found.matched))
  println
  println(output)
}
