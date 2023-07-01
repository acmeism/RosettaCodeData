import java.io.{ FileNotFoundException, PrintWriter }

object FileIO extends App {
  try {
    val MyFileTxtTarget = new PrintWriter("output.txt")

    scala.io.Source.fromFile("input.txt").getLines().foreach(MyFileTxtTarget.println)
    MyFileTxtTarget.close()
  } catch {
    case e: FileNotFoundException => println(e.getLocalizedMessage())
    case e: Throwable => {
      println("Some other exception type:")
      e.printStackTrace()
    }
  }
}
