// Map lines to a list of Option(heading -> task) for each bare lang tag found.
val headerFormat = "==[{]+header[|]([^}]*)[}]+==".r
val langFormat = "<lang([^>]*)>".r
def mapped(lines: Seq[String], taskName: String = "") = {
  var heading = ""
  for (line <- lines;
     head = headerFormat.findFirstMatchIn(line).map(_ group 1);
     lang = langFormat.findFirstMatchIn(line).map(_ group 1)) yield {
    if (head.isDefined) heading = head.get
    lang.map(_.trim).filter(_ == "").map(_ => heading -> taskName)
  }
}
// Group results as a Map(heading -> task1, task2, ...)
def reduced(results: Seq[Option[(String,String)]]) =
  results.flatten.groupBy(_._1).mapValues(_.unzip._2)

// Format each heading as "tasklist.size in heading (tasklist)"
def format(results: Map[String,Seq[String]]) = results.map{case (heading, tasks) =>
  val h = if (heading.length > 0) heading else "no langauge"
  val hmsg = s"${tasks.size} in $h"
  val t = tasks.filterNot(_ == "")
  val tmsg = if (t.isEmpty) "" else t.distinct.mkString(" (", ",", ")")
  hmsg + tmsg
}
def count(results: Map[String,Seq[String]]) = results.values.map(_.size).sum

// Single and multi-source support
case class BareLangFinder(source: scala.io.Source, taskName: String = "") {
  def map = mapped(source.getLines.toSeq, taskName)
  def mapReduce = reduced(map)
  def summary = format(mapReduce) mkString "\n"
}
def mapReduce(inputs: Seq[BareLangFinder]) = reduced(inputs.flatMap(_.map))
