var lines: Iterator[String] = _
try {
  lines = io.Source.fromFile("input.txt").getLines drop(6)
} catch {
  case exc: java.io.IOException =>
    println("File not found")
}
var seventhLine: String = _
if (lines != null) {
  if (lines.isEmpty) println("too few lines in file")
  else seventhLine = lines next
}
if ("" == seventhLine) println("line is empty")
