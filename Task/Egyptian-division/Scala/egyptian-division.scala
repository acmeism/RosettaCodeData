object EgyptianDivision extends App {

  private def divide(dividend: Int, divisor: Int): Unit = {
    val powersOf2, doublings = new collection.mutable.ListBuffer[Integer]

    //populate the powersof2- and doublings-columns
    var line = 0
    while ((math.pow(2, line) * divisor) <= dividend) {
      val powerOf2 = math.pow(2, line).toInt
      powersOf2 += powerOf2
      doublings += (powerOf2 * divisor)
      line += 1
    }

    var answer, accumulator = 0
    //Consider the rows in reverse order of their construction (from back to front of the List)
    var i = powersOf2.size - 1
    for (i <- powersOf2.size - 1 to 0 by -1)
      if (accumulator + doublings(i) <= dividend) {
        accumulator += doublings(i)
        answer += powersOf2(i)
      }

    println(f"$answer%d, remainder ${dividend - accumulator}%d")
  }

  divide(580, 34)

}
