object KlarnerRadoSequence extends App {
  val limit = 1_000_000
  val klarnerRado = initialiseKlarnerRadoSequence(limit)

  println("The first 100 elements of the Klarner-Rado sequence:")
  for (i <- 1 to 100) {
    print(f"${klarnerRado(i)}%3d")
    if (i % 10 == 0) println() else print(" ")
  }
  println()

  var index = 1_000
  while (index <= limit) {
    println(s"The $index th element of Klarner-Rado sequence is ${klarnerRado(index)}")
    index *= 10
  }

  def initialiseKlarnerRadoSequence(limit: Int): Array[Int] = {
    val result = new Array[Int](limit + 1)
    var i2 = 1
    var i3 = 1
    var m2 = 1
    var m3 = 1
    for (i <- 1 to limit) {
      val minimum = math.min(m2, m3)
      result(i) = minimum
      if (m2 == minimum) {
        m2 = result(i2) * 2 + 1
        i2 += 1
      }
      if (m3 == minimum) {
        m3 = result(i3) * 3 + 1
        i3 += 1
      }
    }
    result
  }
}
