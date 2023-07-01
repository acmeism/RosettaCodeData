def permutationsSgn[T]: List[T] => List[(Int,List[T])] = {
  case Nil => List((1,Nil))
  case xs => {
    for {
      (x, i) <- xs.zipWithIndex
      (sgn,ys) <- permutationsSgn(xs.take(i) ++ xs.drop(1 + i))
    } yield {
      val sgni = sgn * (2 * (i%2) - 1)
      (sgni, (x :: ys))
    }
  }
}

def det(m:List[List[Int]]) = {
  val summands =
    for {
      (sgn,sigma) <- permutationsSgn((0 to m.length - 1).toList).toList
    }
    yield {
      val factors =
        for (i <- 0 to (m.length - 1))
        yield m(i)(sigma(i))
      factors.toList.foldLeft(sgn)({case (x,y) => x * y})
    }
  summands.toList.foldLeft(0)({case (x,y) => x + y})
