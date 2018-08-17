object RootsOfAFunction extends App {
    def findRoots(fn: Double => Double, start: Double, stop: Double, step: Double, epsilon: Double) = {
    for {
      x <- start to stop by step
      if fn(x).abs < epsilon
    } yield x
  }

  def fn(x: Double) = x * x * x - 3 * x * x + 2 * x

  println(findRoots(fn, -1.0, 3.0, 0.0001, 0.000000001))
}
