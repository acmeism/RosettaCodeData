object FizzBuzz extends App {
  1 to 100 foreach { n =>
    println((n % 3, n % 5) match {
      case (0, 0) => "FizzBuzz"
      case (0, _) => "Fizz"
      case (_, 0) => "Buzz"
      case _ => n
    })
  }
}
