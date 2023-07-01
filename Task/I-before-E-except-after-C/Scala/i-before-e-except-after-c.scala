object I_before_E_except_after_C extends App {
  val testIE1 = "(^|[^c])ie".r // i before e when not preceded by c
  val testIE2 = "cie".r // i before e when preceded by c
  var countsIE = (0,0)

  val testCEI1 = "cei".r // e before i when preceded by c
  val testCEI2 = "(^|[^c])ei".r // e before i when not preceded by c
  var countsCEI = (0,0)

  scala.io.Source.fromURL("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt").getLines.map(_.toLowerCase).foreach{word =>
    if (testIE1.findFirstIn(word).isDefined) countsIE = (countsIE._1 + 1, countsIE._2)
    if (testIE2.findFirstIn(word).isDefined) countsIE = (countsIE._1, countsIE._2 + 1)
    if (testCEI1.findFirstIn(word).isDefined) countsCEI = (countsCEI._1 + 1, countsCEI._2)
    if (testCEI2.findFirstIn(word).isDefined) countsCEI = (countsCEI._1, countsCEI._2 + 1)
  }

  def plausible(counts: (Int,Int)) = counts._1 > (2 * counts._2)
  def plausibility(plausible: Boolean) = if (plausible) "plausible" else "implausible"
  def plausibility(counts: (Int, Int)): String = plausibility(plausible(counts))
  println("I before E when not preceded by C: "+plausibility(countsIE))
  println("E before I when preceded by C: "+plausibility(countsCEI))
  println("Overall: "+plausibility(plausible(countsIE) && plausible(countsCEI)))
}
