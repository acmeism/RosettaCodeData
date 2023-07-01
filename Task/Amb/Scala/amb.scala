object Amb {

  def amb(wss: List[List[String]]): Option[String] = {
    def _amb(ws: List[String], wss: List[List[String]]): Option[String] = wss match {
      case Nil => ((Some(ws.head): Option[String]) /: ws.tail)((a, w) => a match {
        case Some(x) => if (x.last == w.head) Some(x + " " + w) else None
        case None => None
      })
      case ws1 :: wss1 => ws1.flatMap(w => _amb(w :: ws, wss1)).headOption
    }
    _amb(Nil, wss.reverse)
  }

  def main(args: Array[String]) {
    println(amb(List(List("the", "that", "a"),
                     List("frog", "elephant", "thing"),
                     List("walked", "treaded", "grows"),
                     List("slowly", "quickly"))))
  }
}
