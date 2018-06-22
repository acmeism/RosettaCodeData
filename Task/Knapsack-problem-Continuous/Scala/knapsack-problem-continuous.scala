import scala.annotation.tailrec

object ContinousKnapsackForRobber extends App {
  val MaxWeight = 15.0
  val items = Seq(
    Item("Beef",    3.8, 3600),
    Item("Pork",    5.4, 4300),
    Item("Ham",     3.6, 9000),
    Item("Greaves", 2.4, 4500),
    Item("Flitch",  4.0, 3000),
    Item("Brawn",   2.5, 5600),
    Item("Welt",    3.7, 6700),
    Item("Salami",  3.0, 9500),
    Item("Sausage", 5.9, 9800))

  // sort items by value per unit weight in descending order
  def sortedItems = items.sortBy(it => -it.value / it.weight)

  @tailrec
  def packer(notPacked: Seq[Item], packed: Lootsack): Lootsack = {

    if (!packed.isNotFull || notPacked.isEmpty) packed
    else {
      val try2fit = packed.copy(bagged = notPacked.head +: packed.bagged)
      if (try2fit.isNotFull) packer(notPacked.tail, try2fit)
      else {
        try2fit.copy(lastPiece = packed.weightLeft / notPacked.head.weight)
      }
    }
  }

  case class Item(name: String, weight: Double, value: Int)

  case class Lootsack(bagged: Seq[Item], lastPiece: Double = 1.0) {
    private val totWeight = if (bagged.isEmpty) 0.0
    else bagged.tail.map(_.weight).sum + bagged.head.weight * lastPiece

    def isNotFull: Boolean = weightLeft > 0

    def weightLeft: Double = MaxWeight - totWeight

    override def toString = f"${show(bagged, lastPiece)}Totals: weight: $totWeight%4.1f, value: $totValue%6.2f"

    private def totValue: BigDecimal = if (bagged.isEmpty) 0.0
    else (bagged.tail.map(_.value).sum + bagged.head.value * lastPiece) / 100

    private def show(is: Seq[Item], percentage: Double) = {
      def toStr(is: Seq[Item], percentage: Double = 1): String =
        is.map(it => f"${percentage * 100}%6.2f%% ${it.name}%-7s ${
          it.weight * percentage}%4.1f ${it.value * percentage / 100}%6.2f\n").mkString

      toStr(is.tail.reverse) + toStr(Seq(is.head), percentage)
    }
  }

  println(packer(sortedItems, Lootsack(Nil)))
}
