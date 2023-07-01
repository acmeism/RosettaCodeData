object SumTo100 {
  def main(args: Array[String]): Unit = {
    val exps = expressions(9).map(str => (str, eval(str)))
    val sums = exps.map(_._2).sortWith(_>_)

    val s1 = exps.filter(_._2 == 100)
    val s2 = sums.distinct.map(s => (s, sums.count(_ == s))).maxBy(_._2)
    val s3 = sums.distinct.reverse.filter(_>0).zipWithIndex.dropWhile{case (n, i) => n == i + 1}.head._2 + 1
    val s4 = sums.distinct.take(10)

    println(s"""All ${s1.size} solutions that sum to 100:
               |${s1.sortBy(_._1.length).map(p => s"${p._2} = ${p._1.tail}").mkString("\n")}
               |
               |Most common sum: ${s2._1} (${s2._2})
               |Lowest unreachable sum: $s3
               |Highest 10 sums: ${s4.mkString(", ")}""".stripMargin)
  }

  def expressions(l: Int): LazyList[String] = configurations(l).map(p => p.zipWithIndex.map{case (op, n) => s"${opChar(op)}${n + 1}"}.mkString)
  def configurations(l: Int): LazyList[Vector[Int]] = LazyList.range(0, math.pow(3, l).toInt).map(config(l)).filter(_.head != 0)
  def config(l: Int)(num: Int): Vector[Int] = Iterator.iterate((num%3, num/3)){case (_, n) => (n%3, n/3)}.map(_._1 - 1).take(l).toVector

  def eval(exp: String): Int = (exp.headOption, exp.tail.takeWhile(_.isDigit), exp.tail.dropWhile(_.isDigit)) match{
    case (Some(op), n, str) => doOp(op, n.toInt) + eval(str)
    case _ => 0
  }

  def doOp(sel: Char, n: Int): Int = if(sel == '-') -n else n
  def opChar(sel: Int): String = sel match{
    case -1 => "-"
    case 1 => "+"
    case _ => ""
  }
}
