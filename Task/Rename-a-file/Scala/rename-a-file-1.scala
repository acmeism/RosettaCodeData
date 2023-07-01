import scala.language.implicitConversions
import java.io.File

object Rename0 {
  def main(args: Array[String]) {              // The implicit causes every String to File mapping,
    implicit def file(s: String) = new File(s) // will be converted to new File(String)
    "myfile.txt" renameTo "anotherfile.txt"
    "/tmp/myfile.txt" renameTo "/tmp/anotherfile.txt"
    "mydir" renameTo "anotherdir"
    "/tmp/mydir" renameTo "/tmp/anotherdir"
  }
}
