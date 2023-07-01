def fib(i: Int): Int = i match {
  case 0 => 0
  case 1 => 1
  case _ => fib(i - 1) + fib(i - 2)
}
