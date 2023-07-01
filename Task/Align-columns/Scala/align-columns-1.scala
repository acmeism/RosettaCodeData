object ColumnAligner {
  val eol = System.getProperty("line.separator")
  def getLines(filename: String) = scala.io.Source.fromPath(filename).getLines(eol)
  def splitter(line: String) = line split '$'
  def getTable(filename: String) = getLines(filename) map splitter
  def fieldWidths(fields: Array[String]) = fields map (_ length)
  def columnWidths(txt: Iterator[Array[String]]) = (txt map fieldWidths).toList.transpose map (_ max)

  def alignField(alignment: Char)(width: Int)(field: String) = alignment match {
    case 'l' | 'L' => "%-"+width+"s" format field
    case 'r' | 'R' => "%"+width+"s" format field
    case 'c' | 'C' => val padding = (width - field.length) / 2; " "*padding+"%-"+(width-padding)+"s" format field
    case _ => throw new IllegalArgumentException
  }

  def align(aligners: List[String => String])(fields: Array[String]) =
    aligners zip fields map Function.tupled(_ apply _)

  def alignFile(filename: String, alignment: Char) = {
    def table = getTable(filename)
    val aligners = columnWidths(table) map alignField(alignment)
    table map align(aligners) map (_ mkString " ")
  }

  def printAlignedFile(filename: String, alignment: Char) {
    alignFile(filename, alignment) foreach println
  }
}
