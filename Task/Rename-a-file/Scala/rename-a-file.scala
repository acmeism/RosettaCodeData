object rename {
  def main(args: Array[String]) {
    implicit def file(s: String) = new File(s)
    "myfile.txt" renameTo "anotherfile.txt"
    "/tmp/myfile.txt" renameTo "/tmp/anotherfile.txt"
    "mydir" renameTo "anotherdir"
    "/tmp/mydir" renameTo "/tmp/anotherdir"
  }
}
