import java.io.{File, PrintWriter}

object GloballyReplaceText extends App {

  val (charsetName, fileNames) = ("UTF8", Seq("file1.txt", "file2.txt"))
  for (fileHandle <- fileNames.map(new File(_)))
    new PrintWriter(fileHandle, charsetName) {
      print(scala.io.Source.fromFile(fileHandle, charsetName).mkString
        .replace("Goodbye London!", "Hello New York!"))
      close()
    }

}
