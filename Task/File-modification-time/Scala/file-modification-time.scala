import java.io.File
import java.util.Date

object FileModificationTime extends App {
  def test(file: File) {
    val (t, init) = (file.lastModified(),
      s"The following ${if (file.isDirectory()) "directory" else "file"} called ${file.getPath()}")

    println(init + (if (t == 0) " does not exist." else " was modified at " + new Date(t).toInstant()))
    println(init +
      (if (file.setLastModified(System.currentTimeMillis())) " was modified to current time." else " does not exist."))
    println(init +
      (if (file.setLastModified(t)) " was reset to previous time." else " does not exist."))
  }

  // main
  List(new File("output.txt"), new File("docs")).foreach(test)
}
