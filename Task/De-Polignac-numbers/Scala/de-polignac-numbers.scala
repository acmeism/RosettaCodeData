object DePolignacNumbers extends App {

  println("The first 50 de Polignac numbers:")
  Stream.from(1, 2).filter(isDePolignacNumber).take(10000).zipWithIndex.foreach {
    case (number, index) =>
      val count = index + 1
      if (count <= 50) {
        print(f"$number%5d" + (if (count % 10 == 0) "\n" else " "))
      } else if (count == 1000) {
        println()
        println(s"The 1,000th de Polignac number: $number")
      } else if (count == 10000) {
        println()
        println(s"The 10,000th de Polignac number: $number")
      }
  }

  def isDePolignacNumber(number: Int): Boolean = {
    Iterator.iterate(1)(_ << 1).takeWhile(_ < number).forall(p => !isPrime(number - p))
  }

  def isPrime(number: Int): Boolean = number match {
    case n if n < 2 => false
    case 2 | 3 => true
    case n if n % 2 == 0 || n % 3 == 0 => false
    case _ =>
      Stream.from(5, 2).takeWhile(k => k * k <= number)
        .filter(k => number % k == 0 || number % (k + 2) == 0)
        .isEmpty
  }

}
