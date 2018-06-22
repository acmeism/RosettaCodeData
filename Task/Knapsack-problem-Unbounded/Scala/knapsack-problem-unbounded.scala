import scala.annotation.tailrec

object UnboundedKnapsack extends App {
  private val (maxWeight, maxVolume) = (BigDecimal(25.0), BigDecimal(0.25))
  private val items = Seq(Item("panacea", 3000, 0.3, 0.025), Item("ichor", 1800, 0.2, 0.015), Item("gold", 2500, 2.0, 0.002))

  @tailrec
  private def packer(notPacked: Seq[Knapsack], packed: Seq[Knapsack]): Seq[Knapsack] = {
    def fill(knapsack: Knapsack): Seq[Knapsack] = items.map(i => Knapsack(i +: knapsack.bagged))

    def stuffer(Seq: Seq[Knapsack]): Seq[Knapsack] = // Cause brute force
      Seq.map(k => Knapsack(k.bagged.sortBy(_.name))).distinct

    if (notPacked.isEmpty) packed.sortBy(-_.totValue).take(4)
    else packer(stuffer(notPacked.flatMap(fill)).filter(_.isNotFull), notPacked ++ packed)
  }

  private case class Item(name: String, value: Int, weight: BigDecimal, volume: BigDecimal)

  private case class Knapsack(bagged: Seq[Item]) {
    def isNotFull: Boolean = totWeight <= maxWeight && totVolume <= maxVolume

    override def toString = s"[${show(bagged)} | value: $totValue, weight: $totWeight, volume: $totVolume]"

    def totValue: Int = bagged.map(_.value).sum

    private def totVolume = bagged.map(_.volume).sum

    private def totWeight = bagged.map(_.weight).sum

    private def show(is: Seq[Item]) =
      (items.map(_.name) zip items.map(i => is.count(_ == i)))
        .map { case (i, c) => f"$i:$c%3d" }
        .mkString(", ")
  }

  packer(items.map(i => Knapsack(Seq(i))), Nil).foreach(println)
}
