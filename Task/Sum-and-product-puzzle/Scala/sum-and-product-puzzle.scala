object ImpossiblePuzzle extends App {
  type XY = (Int, Int)
  val step0 = for {
    x <- 1 to 100
    y <- 1 to 100
    if 1 < x && x < y && x + y < 100
  } yield (x, y)

  def sum(xy: XY) = xy._1 + xy._2
  def prod(xy: XY) = xy._1 * xy._2
  def sumEq(xy: XY) = step0 filter { sum(_) == sum(xy) }
  def prodEq(xy: XY) = step0 filter { prod(_) == prod(xy) }

  val step2 = step0 filter { sumEq(_) forall { prodEq(_).size != 1 }}
  val step3 = step2 filter { prodEq(_).intersect(step2).size == 1 }
  val step4 = step3 filter { sumEq(_).intersect(step3).size == 1 }
  println(step4)
}
