val file = try Left(io.Source.fromFile("input.txt")) catch {
  case exc => Right(exc.getMessage)
}
val seventhLine = (for(f <- file.left;
  line <- f.getLines.toStream.drop(6).headOption.toLeft("too few lines").left) yield
    if (line == "") Right("line is empty") else Left(line)).joinLeft
