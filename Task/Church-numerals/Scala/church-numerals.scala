object Church {

  trait ChurchNum extends (ChurchNum => ChurchNum)

  def zero: ChurchNum = f => x => x

  def next(n: ChurchNum): ChurchNum = f => x => f(n(f)(x))

  def plus(a: ChurchNum)(b: ChurchNum): ChurchNum = f => x => b(f)(a(f)(x))

  def mult(a: ChurchNum)(b: ChurchNum): ChurchNum = f => x => b(a(f))(x)

  def pow(m: ChurchNum)(n: ChurchNum): ChurchNum = n(m)

  def toChurchNum(n: Int): ChurchNum = if (n <= 0) zero else next(toChurchNum(n - 1))

  def toInt(c: ChurchNum): Int = {
    var counter = 0
    val funCounter: ChurchNum = f => { counter += 1; f }
    plus(zero)(c)(funCounter)(x => x)
    counter
  }

  def main(args: Array[String]): Unit = {
    val zero = Church.zero
    val three = next(next(next(zero)))
    val four = next(next(next(next(zero))))

    println(s"3+4=${toInt(plus(three)(four))}") // prints 7
    println(s"4+3=${toInt(plus(four)(three))}") // prints 7

    println(s"3*4=${toInt(mult(three)(four))}") // prints 12
    println(s"4*3=${toInt(mult(four)(three))}") // prints 12

    // exponentiation. note the reversed order!
    println(s"3^4=${toInt(pow(four)(three))}") // prints 81
    println(s"4^3=${toInt(pow(three)(four))}") // prints 64

    println(s"  8=${toInt(toChurchNum(8))}") // prints 8
  }
}
