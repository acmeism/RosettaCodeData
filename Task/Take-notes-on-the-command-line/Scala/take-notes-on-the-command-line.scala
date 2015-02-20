import java.io.{ FileNotFoundException, FileOutputStream, PrintStream }
import java.time.LocalDateTime

object TakeNotes extends App {
  val notesFileName = "notes.txt"
  if (args.length > 0) {
    val ps = new PrintStream(new FileOutputStream(notesFileName, true))
    ps.println(LocalDateTime.now() + args.mkString("\n\t", " ", "."))
    ps.close()
  } else try {
    io.Source.fromFile(notesFileName).getLines().foreach(println)
  } catch {
    case e: FileNotFoundException => println(e.getLocalizedMessage())
    case e: Throwable => {
      println("Some other exception type:")
      e.printStackTrace()
    }
  }
}
