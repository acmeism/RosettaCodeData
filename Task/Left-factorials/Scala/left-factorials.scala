object LeftFactorial extends App {

  // this part isn't really necessary, it just shows off Scala's ability
  // to match the mathematical syntax: !n
  implicit class RichInt(n:Int) {
    def unary_!() = factorial.take(n).sum
  }

  val factorial: Stream[BigInt] = 1 #:: factorial.zip(Stream.from(1)).map(n => n._2 * factorial(n._2 - 1))

  for (n <- (0 to 10) ++
            (20 to 110 by 10);
       value = !n) {
    println(s"!${n} = ${value}")
  }
  for (n <- 1000 to 10000 by 1000;
       length = (!n).toString.length) {
    println(s"length !${n} = ${length}")
  }
}
