// What about this, could also equipped with an implicit.
object Rename1 {
  def main(args: Array[String]) {
    for { fsObject <- List(("myfile.txt", "anotherfile.txt"),("/tmp/myfile.txt", "/tmp/anotherfile.txt"),
          ("mydir", "anotherdir"),("/tmp/mydir", "/tmp/anotherdir"))
        } new File(fsObject._1) renameTo new File(fsObject._2)
  }
}
