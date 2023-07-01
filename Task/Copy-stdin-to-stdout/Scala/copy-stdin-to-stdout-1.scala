object CopyStdinToStdout extends App {
  io.Source.fromInputStream(System.in).getLines().foreach(println)
}
