import collection.mutable.ListBuffer
case class State(isChild: Boolean, alts: ListBuffer[String], rem: List[Char])
def expand(s: String): Seq[String] = {
  def parseGroup(s: State): State = s.rem match {
    case Nil =>  s.copy(alts = ListBuffer("{" + s.alts.mkString(",")))
    case ('{' | ',')::sp =>
      val newS = State(true, ListBuffer(""), rem = sp)
      val elem = parseElem(newS)
      elem.rem match {
        case Nil =>     elem.copy(alts = elem.alts.map(a => "{" + s.alts.map(_ + ",").mkString("") + a))
        case elemrem => parseGroup(s.copy(alts = (s.alts ++= elem.alts), rem = elem.rem))
      }
    case '}'::sp =>
      if (s.alts.isEmpty)          s.copy(alts = ListBuffer("{}"), rem = sp)
      else if(s.alts.length == 1)  s.copy(alts = ListBuffer("{"+s.alts.head + "}"), rem = sp)
      else                         s.copy(rem = sp)
    case _ => throw new Exception("parseGroup should be called only with delimitors")
  }
  def parseElem(s: State): State = s.rem match {
    case Nil =>  s
    case '{'::sp =>
      val ys = parseGroup(State(true, ListBuffer(), s.rem))
      val newAlts = for { x <- s.alts; y <- ys.alts} yield x + y
      parseElem(s.copy(alts = newAlts, rem = ys.rem))
    case (',' | '}')::_ if s.isChild => s
    case '\\'::c::sp => parseElem(s.copy(alts = s.alts.map(_ + '\\' + c), rem = sp))
    case c::sp =>       parseElem(s.copy(alts = s.alts.map(_ + c), rem = sp))
  }
  parseElem(State(false, ListBuffer(""), s.toList)).alts
}
