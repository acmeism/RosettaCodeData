object Rename1 {
  def main(args: Array[String]) {
    List(("myfile.txt", "anotherfile.txt"),("/tmp/myfile.txt", "/tmp/anotherfile.txt"),
         ("mydir", "anotherdir"),("/tmp/mydir", "/tmp/anotherdir")).foreach{ case (oldf, newf) ⇒
      new java.io.File(oldf) renameTo new java.io.File(newf)
    }
  }
}
