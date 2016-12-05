import scala.annotation.tailrec

case class Item(name: String, value: Int, weight: Double, volume: Double)

val items = List(
  Item("panacea", 3000, 0.3, 0.025),
  Item("ichor", 1800, 0.2, 0.015),
  Item("gold", 2500, 2.0, 0.002))

val (maxWeight, maxVolume) = (25, 0.25)

def show(is: List[Item]) =
  (items.map(_.name) zip items.map(i => is.count(_ == i))).map {
    case (i, c) => s"$i: $c"
  }.mkString(", ")

case class Knapsack(items: List[Item]) {
  def value = items.foldLeft(0)(_ + _.value)
  def weight = items.foldLeft(0.0)(_ + _.weight)
  def volume = items.foldLeft(0.0)(_ + _.volume)
  def isFull = !((weight <= maxWeight) && (volume <= maxVolume))
  override def toString =
    s"[${show(items)} | value: $value, weight: $weight, volume: $volume]"
}

def fill(knapsack: Knapsack): List[Knapsack] =
  items.map(i => Knapsack(i :: knapsack.items))

//cause brute force
def distinct(list: List[Knapsack]) =
  list.map(k => Knapsack(k.items.sortBy(_.name))).distinct

@tailrec
def f(notPacked: List[Knapsack], packed: List[Knapsack]): List[Knapsack] =
  notPacked match {
    case Nil => packed.sortBy(_.value).takeRight(4)
    case _ =>
      val notFull = distinct(notPacked.flatMap(fill)).filterNot(_.isFull)
      f(notFull, notPacked ::: packed)
  }

f(items.map(i => Knapsack(List(i))), Nil).foreach(println)
