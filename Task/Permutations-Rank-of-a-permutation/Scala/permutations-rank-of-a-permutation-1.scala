import scala.math._

def factorial(n: Int): BigInt = {
  (1 to n).map(BigInt.apply).fold(BigInt(1))(_ * _)
}

def indexToPermutation(n: Int, x: BigInt): List[Int] = {
  indexToPermutation((0 until n).toList, x)
}

def indexToPermutation(ns: List[Int], x: BigInt): List[Int] = ns match {
  case Nil => Nil
  case _ => {
    val (iBig, xNew) = x /% factorial(ns.size - 1)
    val i = iBig.toInt
    ns(i) :: indexToPermutation(ns.take(i) ++ ns.drop(i + 1), xNew)
  }
}

def permutationToIndex[A](xs: List[A])(implicit ord: Ordering[A]): BigInt = xs match {
  case Nil => BigInt(0)
  case x :: rest => factorial(rest.size) * rest.count(ord.lt(_, x)) + permutationToIndex(rest)
}
