import java.io.File

object FileSize extends App {
  val name = "pg1661.txt"

  println(s"$name  : ${new File(name).length()} bytes")
  println(s"/$name : ${new File(s"${File.separator}$name").length()} bytes")
}
