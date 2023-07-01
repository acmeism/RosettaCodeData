object SimpleDatabase extends App {
  type Entry = Array[String]
  def asTSV(e: Entry) = e mkString "\t"
  def fromTSV(s: String) = s split "\t"
  val header = asTSV(Array("TIMESTAMP", "DESCRIPTION", "CATEGORY", "OTHER"))

  def read(filename: String) = try {
    scala.io.Source.fromFile(filename).getLines.drop(1).map(fromTSV)
  } catch {
    case e: java.io.FileNotFoundException => Nil
  }

  def write(filename: String, all: Seq[Entry]) = {
    import java.nio.file.{Files,Paths}
    import scala.collection.JavaConversions.asJavaIterable
    Files.write(Paths.get(filename), asJavaIterable(header +: all.map(asTSV)))
    all.size
  }

  def add(filename: String, description: String, category: String = "none", optional: Seq[String] = Nil) {
    val format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    val e = Array(format.format(new java.util.Date), description, category) ++ optional
    println(write(filename, read(filename).toBuffer :+ e) + " entries")
  }

  def print(filename: String, filter: Seq[Entry] => TraversableOnce[Entry]) =
    filter(read(filename).toList.sortBy(_.headOption)) map(_ mkString ",") foreach println

  args match {
    case Array(f, "latest") => print(f, _ takeRight 1)
    case Array(f, "latest", cat) => print(f, _ filter(_.lift(2) == Some(cat)) takeRight 1)
    case Array(f, "all") => print(f, _.toSeq)
    case Array(f, "all", "latest") => print(f, _ groupBy (_ lift 2 getOrElse "") map{case (_, cat) => cat.last})
    case Array(f, "add", desc) => add(f, desc, category = "")
    case Array(f, "add", desc, cat, opt @ _*) => add(f, desc, cat, opt)
    case _ => println("Usage: SimpleDatabase filename.tsv [all [latest]| latest [CATEGORY] | add [DESCRIPTION [CATEGORY [OPTIONAL]...]]]")
  }
}
