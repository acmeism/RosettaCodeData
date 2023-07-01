import java.io.IOException

object Fork extends App {
  val builder: ProcessBuilder = new ProcessBuilder()
  val currentUser: String = builder.environment.get("USER")
  val command: java.util.List[String] = java.util.Arrays.asList("ps", "-f", "-U", currentUser)
  builder.command(command)
  try {
    val lines = scala.io.Source.fromInputStream(builder.start.getInputStream).getLines()
    println(s"Output of running $command is:")
    while (lines.hasNext) println(lines.next())
  }
  catch {
    case iox: IOException => iox.printStackTrace()
  }
}
