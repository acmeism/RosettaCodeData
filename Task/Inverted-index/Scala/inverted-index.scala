object InvertedIndex extends App {
  import java.io.File

  // indexer
  val WORD = raw"(\w+)".r
  def parse(s: String) = WORD.findAllIn(s).map(_.toString.toLowerCase)
  def invertedIndex(files: Seq[File]): Map[String,Set[File]] = {
    var i = Map[String,Set[File]]() withDefaultValue Set.empty
    files.foreach{f => scala.io.Source.fromFile(f).getLines flatMap parse foreach
      (w => i = i + (w -> (i(w) + f)))}
    i
  }

  // user interface
  args match {
    case _ if args.length < 2 => println("Usage: InvertedIndex ALLSEARCHWORDS FILENAME...")
    case Array(searchwords, filenames @ _*) =>
      val queries = parse(searchwords).toList
      val files = filenames.map(new File(_)).filter{f => if (!f.exists) println(s"Ignoring $f"); f.exists}
      (queries, files) match {
        case (q, _) if q.isEmpty => println("Missing search words")
        case (_, f) if f.isEmpty => println("Missing extant files")
        case _ => val index = invertedIndex(files)
          println(s"""Searching for ${queries map ("\""+_+"\"") mkString " and "} in ${files.size} files:""")
          queries.map(index).foldLeft(files.toSet)(_ intersect _) match {
            case m if m.isEmpty => println("No matching files")
            case m => println(m mkString "\n")
          }
      }
  }
}
