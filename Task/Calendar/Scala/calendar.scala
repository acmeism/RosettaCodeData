import java.util.TimeZone
import java.util.Locale
import java.util.Calendar
import java.util.GregorianCalendar

object Helper {
  def monthsMax(locale: Locale = Locale.getDefault): Int = {
    val cal = Calendar.getInstance(locale)
    cal.getMaximum(Calendar.MONTH)
  }

  def numberOfMonths(locale: Locale = Locale.getDefault): Int = monthsMax(locale)+1

  def namesOfMonths(year: Int, locale: Locale = Locale.getDefault): List[String] = {
    val cal = Calendar.getInstance(locale)
    val f1: Int => String = i => {
      cal.set(year,i,1)
      cal.getDisplayName(Calendar.MONTH, Calendar.LONG, locale)
    }
    (0 to monthsMax(locale)) map f1 toList
  }

  def jgt(cal: GregorianCalendar): Int = {cal.setTime(cal.getGregorianChange); cal.get(Calendar.YEAR)}

  def isJGT(year: Int, cal: GregorianCalendar) = year==jgt(cal)

  def offsets(year: Int, locale: Locale = Locale.getDefault): List[Int] = {
    val cal = Calendar.getInstance(locale)
    val months = cal.getMaximum(Calendar.MONTH)
    val f1: Int => Int = i => {
      cal.set(year,i,1)
      cal.get(Calendar.DAY_OF_WEEK)
    }
    ((0 to months) map f1 toList) map {i=>if((i-2)<0) i+5 else i-2}
  }

  def headerNameOfDays(locale: Locale = Locale.getDefault) = {
    val cal = Calendar.getInstance(locale)
    val mdow = cal.getDisplayNames(Calendar.DAY_OF_WEEK, Calendar.SHORT, locale) // map days of week
    val it = mdow.keySet.iterator
    import scala.collection.mutable.ListBuffer
    val lb = new ListBuffer[String]
    while (it.hasNext) lb+=it.next
    val lpdow = lb.toList.map{k=>(mdow.get(k),k.substring(0,2))} // list pair days of week
    (lpdow map {p=>if((p._1-2)<0) (p._1+5, p._2) else (p._1-2, p._2)} sortWith(_._1<_._1) map (_._2)).foldRight("")(_+" "+_)
  }

}

object CalendarPrint extends App {
  import Helper._

  val tzd = TimeZone.getDefault
  val locd = Locale.getDefault

  def printCalendar(year: Int, printerWidth: Int, loc: Locale, tz: TimeZone) = {

    def getCal: List[Triple[Int, Int, String]] = {
      val cal = new GregorianCalendar(tz, loc)

      def getGregCal: List[Triple[Int, Int, String]] = {
        val month = 0
        val day = 1
        cal.set(year,month,day)
        val f1: Int => Triple[Int, Int, Int] = i => {
          val cal = Calendar.getInstance(tz, loc)
          cal.set(year,i,1)
          val minday = cal.getActualMinimum(Calendar.DAY_OF_MONTH)
          val maxday = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
          (i, minday, maxday)
        }
        val limits = (0 to monthsMax(loc)) map f1
        val f2: (Int, Int, Int) => String = (year, month, day) => {
          val cal = Calendar.getInstance(tz, loc)
          cal.set(year,month,day)
          cal.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, loc)
        }
        val calend = for {
          i <- 0 to monthsMax(loc)
          j <- limits(i)._2 to limits(i)._3
          val dow = f2(year, i, j)
        } yield (i, j, dow)
        if (isJGT(year, new GregorianCalendar(tz, loc))) calend.filter{_._1!=9}.toList else calend.toList
      }

      def getJGT: List[Triple[Int, Int, String]] = {
        if (!isJGT(year, new GregorianCalendar(tz, loc))) return Nil

        val cal = new GregorianCalendar(tz, loc)
        cal.set(year,9,1)
        var ldom = 0
        def it = new Iterator[Tuple3[Int,Int, String]]{
          def next={
            val res = (cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), cal.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.GERMAN))
            ldom = res._2
            cal.roll(Calendar.DAY_OF_MONTH, true)
            res
          }
          def hasNext = (cal.get(Calendar.DAY_OF_MONTH)>ldom)
        }
        it.toList
      }
      (getGregCal++getJGT).sortWith((s,t)=>s._1*100+s._2<t._1*100+t._2)
    }

    def printCal(calList: List[Triple[Int, Int, String]]) = {
      val pwmax = 300   // printer width maximum
      val mw = 20   // month width
      val gwf = 2   // gap width fixed
      val gwm = 2   // gap width minimum
      val fgw = true

      val arr = Array.ofDim[String](6,7)
      def clear = for (i <- 0 until 6) for (j <- 0 until 7) arr(i)(j) = "  "

      def limits(printerWidth: Int): Tuple5[Int, Int, Int, Int, Int] = {
        val pw = if (printerWidth<20) 20 else if (printerWidth>300) 300 else printerWidth

        def getFGW(msbs: Int,gsm: Int) = {val r=(pw-msbs*mw-gsm)/2; (r,gwf,r)}   // fixed gap width
        def getVGW(msbs: Int,gsm: Int) = pw-msbs*mw-gsm match {                  // variable gap width
                                           case a if (a<2*gwm) => (a/2,gwm,a/2)
                                           case b => {val x = (b+gsm)/(msbs+1); (x,x,x)}
                                         }

        // months side by side, gaps sum minimum
        val (msbs, gsm) = {
          val (x, y) = {val c = if (pw/mw>12) 12 else pw/mw; if (c*mw+(c-1)*gwm<=pw) (c, c*gwm) else (c-1, (c-1)*gwm)}
          val x1 = x match {
            case 5 => 4
            case a if (a>6 && a<12) => 6
            case other => other
          }
          (x1, (x1-1)*gwm)
        }

        // left margin, gap width, right margin
        val (lm,gw,rm) = if (fgw) getFGW(msbs,gsm) else getVGW(msbs,gsm)
        (pw,msbs,lm,gw,rm)
      }

      val (pw,msbs,lm,gw,rm) = limits(printerWidth)
      val monthsList = (0 to monthsMax(loc)).map{m=>calList.filter{_._1==m}}.toList
      val nom = namesOfMonths(year,loc)
      val offsetList = offsets(year,loc)
      val hnod = headerNameOfDays(loc)

      val fsplit: List[(Int, Int, String)] => List[String] = list => {
	    val fap: Int => (Int, Int) = p => (p/7,p%7)
	    clear
	    for (i <- 0 until list.size) arr(fap(i+offsetList(list(i)._1))._1)(fap(i+offsetList(list(i)._1))._2)="%2d".format(list(i)._2)
	    //arr.toList.map(_.toList).map(_.foldLeft("")(_+" "+_))
	    arr.toList.map(_.toList).map(_.foldRight("")(_+" "+_))
	  }
      val monthsRows = monthsList.map(fsplit)

      val center: (String, Int) => String = (s,l) => {
        if (s.size>=l) s.substring(0,l) else
        (" "*((l-s.size)/2)+s+" "*((l-s.size)/2)+" ").substring(0,l)
      }

      println(center("[Snoopy Picture]",pw))
      println
      println(center(""+year,pw))
      println

      val ul = numberOfMonths(loc)
      val rowblocks = (1 to ul/msbs).map{i=>
        (0 to 5).map{j=>
          val lb = new scala.collection.mutable.ListBuffer[String]
          val k = (i-1)*msbs
          (k to k+msbs-1).map{l=>
            lb+=monthsRows(l)(j)
          }
          lb.toList
        }.toList
      }.toList

      val mheaders = (1 to ul/msbs).map{i=>(0 to msbs-1).map{j=>center(nom(j+(i-1)*msbs),20)}.toList}.toList
      val dowheaders = (1 to ul/msbs).map{i=>(0 to msbs-1).map{j=>center(hnod,20)}.toList}.toList

      (1 to 12/msbs).foreach{i=>
        println(" "*lm+mheaders(i-1).foldRight("")(_+" "*gw+_))
        println(" "*lm+dowheaders(i-1).foldRight("")(_+" "*gw+_))
        rowblocks(i-1).foreach{xs=>println(" "*lm+xs.foldRight("")(_+" "*(gw-1)+_))}
        println
      }

    }

    val calList = getCal
    printCal(calList)

  }

  def printGregCal(year: Int = 1969, pw: Int = 80, JGT: Boolean = false, loc: Locale = Locale.getDefault, tz: TimeZone = TimeZone.getDefault) {
    val _year = if (JGT==false) year else jgt(new GregorianCalendar(tz, loc))
    printCalendar(_year, pw, loc, tz)
  }

  printGregCal()
  printGregCal(JGT=true, loc=Locale.UK, pw=132, tz=TimeZone.getTimeZone("UK/London"))

}
