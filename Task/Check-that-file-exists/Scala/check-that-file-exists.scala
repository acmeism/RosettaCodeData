import java.nio.file.{ Files, FileSystems }

object FileExistsTest extends App {

  val defaultFS = FileSystems.getDefault()
  val separator = defaultFS.getSeparator()

  def test(filename: String) {
    val path = defaultFS.getPath(filename)

    println(s"The following ${if (Files.isDirectory(path)) "directory" else "file"} called $filename" +
      (if (Files.exists(path)) " exists." else " not exists."))
  }

  // main
  List("output.txt", separator + "output.txt", "docs", separator + "docs" + separator).foreach(test)
}
