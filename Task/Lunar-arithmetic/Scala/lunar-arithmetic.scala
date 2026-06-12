import scala.collection.mutable.TreeSet

object LunarArithmetic {

  def main(args: Array[String]): Unit = {
    val testCases = List(
      List(976, 348),
      List(23, 321),
      List(232, 35),
      List(123, 32192, 415, 8)
    )

    testCases.foreach { test =>
      val addExpression = test.map(_.toString).mkString(" 🌙 + ")
      val addResult = test.map(Lunar(_)).reduce(_ + _)
      println(s"$addExpression = $addResult")

      val multiplyExpression = test.map(_.toString).mkString(" 🌙 x ")
      val multiplyResult = test.map(Lunar(_)).reduce(_ * _)
      println(s"$multiplyExpression = $multiplyResult")
      println()
    }

    println("First 20 distinct lunar even numbers:")
    val evens = TreeSet[Lunar]()
    var n = Lunar.ZERO
    while (evens.size < 20) {
      evens += n * Lunar(2)
      n = n.increment()
    }
    println(evens.mkString(" "))
    println()

    println("First 20 lunar square numbers:")
    (0 until 20).foreach { i =>
      val lunar = Lunar(i)
      print(s"${lunar * lunar} ")
    }
    println("\n")

    println("First 20 lunar factorials:")
    var factorial = Lunar(1)
    for (i <- 1 to 20) {
      factorial = factorial * Lunar(i)
      print(s"$factorial ")
    }
    println("\n")

    var current = Lunar.ZERO
    var next = Lunar.ZERO
    while ((current * current).compareTo(next * next) <= 0) {
      current = next
      next = next.increment()
    }
    println(s"First number whose lunar square is smaller than the previous: $next")
  }
}

case class Lunar(value: Long) extends Ordered[Lunar] {

  require(value >= 0, "Argument must be a non-negative integer.")

  private val text = value.toString

  def +(other: Lunar): Lunar = {
    val maxLength = math.max(text.length, other.text.length)
    val a = "0" * (maxLength - text.length) + text
    val b = "0" * (maxLength - other.text.length) + other.text

    val sum = a.zip(b).map { case (digitA, digitB) =>
      math.max(digitA, digitB).toChar
    }.mkString

    Lunar(sum.toLong)
  }

  def *(other: Lunar): Lunar = {
    var result = Lunar.ZERO
    val reversed = other.text.reverse

    for ((digit, i) <- reversed.zipWithIndex) {
      val row = text.map(textDigit => math.min(textDigit, digit).toChar).mkString + "0" * i
      result = result + Lunar(row.toLong)
    }

    result
  }

  def increment(): Lunar = Lunar(value + 1)

  override def compare(other: Lunar): Int = value.compare(other.value)

  override def toString: String = text
}

object Lunar {
  val ZERO = Lunar(0) // Additive identity
  val NINE = Lunar(9) // Multiplicative identity
}
