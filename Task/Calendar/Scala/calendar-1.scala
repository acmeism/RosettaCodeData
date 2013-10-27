import java.util.{ Calendar, GregorianCalendar }
import language.postfixOps
import collection.mutable.ListBuffer

object CalendarPrint extends App {
  val locd = java.util.Locale.getDefault()
  val cal = new GregorianCalendar
  val monthsMax = cal.getMaximum(Calendar.MONTH)

  def JDKweekDaysToISO(dn: Int) = {
    val nday = dn - Calendar.MONDAY
    if (nday < 0) (dn + Calendar.THURSDAY) else nday
  }

  def daysInMonth(year: Int, monthMinusOne: Int): Int = {
    cal.set(year, monthMinusOne, 1)
    cal.getActualMaximum(Calendar.DAY_OF_MONTH)
  }

  def namesOfMonths() = {
    def f1(i: Int): String = {
      cal.set(2013, i, 1)
      cal.getDisplayName(Calendar.MONTH, Calendar.LONG, locd)
    }
    (0 to monthsMax) map f1
  }

  def offsets(year: Int): List[Int] = {
    val months = cal.getMaximum(Calendar.MONTH)
    def get1stDayOfWeek(i: Int) = {
      cal.set(year, i, 1)
      cal.get(Calendar.DAY_OF_WEEK)
    }
    (0 to monthsMax).toList map get1stDayOfWeek map { i => JDKweekDaysToISO(i) }
  }

  def headerNameOfDays() = {
    val mdow = cal.getDisplayNames(Calendar.DAY_OF_WEEK, Calendar.SHORT, locd) // map days of week
    val it = mdow.keySet.iterator
    val keySet = new ListBuffer[String]
    while (it.hasNext) keySet += it.next
    (keySet.map { key => (JDKweekDaysToISO(mdow.get(key)), key.take(2))
    }.sortWith(_._1 < _._1) map (_._2)).mkString(" ")
  }

  def getGregCal(year: Int) = {
    {

      def dayOfMonth(month: Int) = new Iterator[(Int, Int)] {
        cal.set(year, month, 1)
        var ldom = 0

        def next() = {
          val res = (cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH))
          ldom = res._2
          cal.roll(Calendar.DAY_OF_MONTH, true)
          res
        }

        def hasNext() = (cal.get(Calendar.DAY_OF_MONTH) > ldom)
      }
      var ret: List[(Int, Int)] = Nil
      for (i <- 0 to monthsMax) ret = ret ++ (dayOfMonth(i).toSeq)
      (ret, offsets(year))
    }
  }

  def printCalendar(calendar: (List[(Int, Int)], List[Int]),
                    headerList: List[String] = Nil,
                    printerWidth: Int = 80) = {
    val mw = 20 // month width
    val gwf = 2 // gap width fixed
    val gwm = 2 // gap width minimum
    val fgw = true

    val arr = Array.ofDim[String](6, 7)

    def limits(printerWidth: Int): (Int, Int, Int, Int, Int) = {
      val pw = if (printerWidth < 20) 20 else if (printerWidth > 300) 300 else printerWidth

      // months side by side, gaps sum minimum
      val (msbs, gsm) = {
        val x1 = {
          val c = if (pw / mw > 12) 12 else pw / mw
          val a = (c - 1)
          if (c * mw + a * gwm <= pw) c else a
        } match {
          case 5                      => 4
          case a if (a > 6 && a < 12) => 6
          case other                  => other
        }
        (x1, (x1 - 1) * gwm)
      }

      def getFGW(msbs: Int, gsm: Int) = { val r = (pw - msbs * mw - gsm) / 2; (r, gwf, r) } // fixed gap width
      def getVGW(msbs: Int, gsm: Int) = pw - msbs * mw - gsm match { // variable gap width
        case a if (a < 2 * gwm) => (a / 2, gwm, a / 2)
        case b                  => { val x = (b + gsm) / (msbs + 1); (x, x, x) }
      }

      // left margin, gap width, right margin
      val (lm, gw, rm) = if (fgw) getFGW(msbs, gsm) else getVGW(msbs, gsm)
      (pw, msbs, lm, gw, rm)
    } // def limits(

    val (pw, msbs, lm, gw, rm) = limits(printerWidth)
    val monthsList = (0 to monthsMax).map { m => calendar._1.filter { _._1 == m } }
    val nom = namesOfMonths()
    val hnod = headerNameOfDays

    def fsplit(list: List[(Int, Int)]): List[String] = {
      def fap(p: Int) = (p / 7, p % 7)
      for (i <- 0 until 6) for (j <- 0 until 7) arr(i)(j) = "  "
      for (i <- 0 until list.size)
        arr(fap(i + calendar._2(list(i)._1))._1)(fap(i + calendar._2(list(i)._1))._2) =
          f"${(list(i)._2)}%2d"
      arr.toList.map(_.foldRight("")(_ + " " + _))
    }
    val monthsRows = monthsList.map(fsplit)

    def center(s: String, l: Int): String = {
      (if (s.size >= l) s
      else " " * ((l - s.size) / 2) + s + " " * ((l - s.size) / 2) + " ").substring(0, l)
    }

    val maxMonths = monthsMax + 1

    val rowblocks = (1 to maxMonths / msbs).map { i =>
      (0 to 5).map { j =>
        val lb = new ListBuffer[String]
        val k = (i - 1) * msbs
        (k to k + msbs - 1).map { l => lb += monthsRows(l)(j) }
        lb
      }
    }

    val mheaders = (1 to maxMonths / msbs).
      map { i => (0 to msbs - 1).map { j => center(nom(j + (i - 1) * msbs), 20) } }
    val dowheaders = (1 to maxMonths / msbs).
      map { i => (0 to msbs - 1).map { j => center(hnod, 20) } }

    headerList.foreach(xs => println(center(xs + '\n', pw)))
    (1 to 12 / msbs).foreach { i =>
      println(" " * lm + mheaders(i - 1).foldRight("")(_ + " " * gw + _))
      println(" " * lm + dowheaders(i - 1).foldRight("")(_ + " " * gw + _))
      rowblocks(i - 1).foreach { xs => println(" " * lm + xs.foldRight("")(_ + " " * (gw - 1) + _)) }
      println
    }
  } //  def printCal(

  printCalendar(getGregCal(1969), List("[Snoopy Picture]", "1969"))
  printCalendar(getGregCal(1582), List("[Snoopy Picture]", "1582"), printerWidth = 132)
}
