import scala.annotation.tailrec
@tailrec
final def fib(x: Int, prev: BigInt = 0, next: BigInt = 1): BigInt = x match {
  case 0 => prev
  case _ => fib(x - 1, next, next + prev)
}
