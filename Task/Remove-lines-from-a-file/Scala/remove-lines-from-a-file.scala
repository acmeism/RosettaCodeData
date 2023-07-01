object RemoveLinesFromAFile extends App {
  args match {
    case Array(filename, start, num) =>

      import java.nio.file.{Files,Paths}
      val lines = scala.io.Source.fromFile(filename).getLines
      val keep = start.toInt - 1
      val top = lines.take(keep).toList
      val drop = lines.take(num.toInt).toList
      Files.write(Paths.get(filename), scala.collection.JavaConversions.asJavaIterable(top ++ lines))

      if (top.size < keep || drop.size < num.toInt)
        println(s"Too few lines: removed only ${drop.size} of $num lines starting at $start")

    case _ =>
      println("Usage: RemoveLinesFromAFile <filename> <startLine> <numLines>")
  }
}
