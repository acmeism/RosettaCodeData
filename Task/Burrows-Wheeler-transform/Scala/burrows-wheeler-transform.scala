import scala.collection.mutable.ArrayBuffer

object BWT {
  val STX = '\u0002'
  val ETX = '\u0003'

  def bwt(s: String): String = {
    if (s.contains(STX) || s.contains(ETX)) {
      throw new RuntimeException("String can't contain STX or ETX")
    }
    var ss = STX + s + ETX
    var table = new ArrayBuffer[String]()
    (0 until ss.length).foreach(_ => {
      table += ss
      ss = ss.substring(1) + ss.charAt(0)
    })
    table.sorted.map(a => a.last).mkString
  }

  def ibwt(r: String): String = {
    var table = Array.fill(r.length)("")
    (0 until r.length).foreach(_ => {
      (0 until r.length).foreach(i => {
        table(i) = r.charAt(i) + table(i)
      })
      table = table.sorted
    })
    table.indices.foreach(i => {
      val row = table(i)
      if (row.last == ETX) {
        return row.substring(1, row.length - 1)
      }
    })
    ""
  }

  def makePrintable(s: String): String = {
    s.replace(STX, '^').replace(ETX, '|')
  }

  def main(args: Array[String]): Unit = {
    val tests = Array("banana",
      "appellee",
      "dogwood",
      "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
      "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
      "\u0002ABC\u0003"
    )

    tests.foreach(test => {
      println(makePrintable(test))
      print(" --> ")

      try {
        val t = bwt(test)
        println(makePrintable(t))
        val r = ibwt(t)
        printf(" --> %s\n", r)
      } catch {
        case e: Exception => printf("ERROR: %s\n", e.getMessage)
      }

      println()
    })
  }
}
