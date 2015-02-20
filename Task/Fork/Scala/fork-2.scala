import java.io.IOException

object Fork extends App {
  val command: java.util.List[String] = java.util.Arrays.asList("cmd.exe", "/C", "ECHO.| TIME")
  val builder: ProcessBuilder = new ProcessBuilder(command)
  try {
    val lines = scala.io.Source.fromInputStream(builder.start.getInputStream).getLines()
    println(s"Output of running $command is:")
    while (lines.hasNext) println(lines.next())
  }
  catch {
    case iox: IOException => iox.printStackTrace()
  }
}
