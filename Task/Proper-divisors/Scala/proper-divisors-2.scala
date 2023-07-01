import scala.annotation.tailrec

def factorize(x: BigInt): List[BigInt] = {
  @tailrec
  def foo(x: BigInt, a: BigInt = 2, list: List[BigInt] = Nil): List[BigInt] = a * a > x match {
    case false if x % a == 0 => foo(x / a, a, a :: list)
    case false => foo(x, a + 1, list)
    case true => x :: list
  }

  foo(x)
}

def properDivisors(n: BigInt): List[BigInt] = {
  val factors = factorize(n)
  val products = (1 until factors.length).flatMap(i => factors.combinations(i).map(_.product).toList).toList
  (BigInt(1) :: products).filter(_ < n)
}
