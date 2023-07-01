object PythagoreanTriples extends App {

  println("               Limit Primatives          All")

  for {e <- 2 to 7
       limit = math.pow(10, e).longValue()
  } {
    var primCount, tripCount = 0

    def parChild(a: BigInt, b: BigInt, c: BigInt): Unit = {
      val perim = a + b + c
      val (a2, b2, c2, c3) = (2 * a, 2 * b, 2 * c, 3 * c)
      if (limit >= perim) {
        primCount += 1
        tripCount += (limit / perim).toInt
        parChild(a - b2 + c2, a2 - b + c2, a2 - b2 + c3)
        parChild(a + b2 + c2, a2 + b + c2, a2 + b2 + c3)
        parChild(-a + b2 + c2, -a2 + b + c2, -a2 + b2 + c3)
      }
    }

    parChild(BigInt(3), BigInt(4), BigInt(5))
    println(f"a + b + c <= ${limit.toFloat}%3.1e  $primCount%9d $tripCount%12d")
  }
}
