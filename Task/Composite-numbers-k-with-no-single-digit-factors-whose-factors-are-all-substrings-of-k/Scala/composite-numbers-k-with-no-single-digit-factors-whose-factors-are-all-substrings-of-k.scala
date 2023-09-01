def isComposite(num: Int): Boolean = {
    val numStr = num.toString
    def iter(n: Int, start: Int): Boolean = {
        val limit = math.sqrt(n).floor.toInt
       (start to limit by 2).dropWhile(n % _ > 0).headOption match {
            case Some(v) if v < 10 => false
            case Some(v) =>
                    if (v == start || numStr.contains(v.toString)) iter(n / v, v)
                    else false
            case None => n < num && numStr.contains(n.toString)
        }
    }
    iter(num, 3)
}

def composites = Iterator.from(121, 2).filter(isComposite(_))

@main def main = {
    val start = System.currentTimeMillis
    composites.take(20)
        .grouped(10)
        .foreach(grp => println(grp.map("%8d".format(_)).mkString(" ")))
    val time = System.currentTimeMillis - start
    println(s"time elapsed: $time ms")
}
