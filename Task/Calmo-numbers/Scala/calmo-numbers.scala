object Main extends App {

  def isPrime(n: Int): Boolean = {
    for (i <- 2 to math.sqrt(n).toInt) {
      if (n % i == 0) {
        return false
      }
    }
    true
  }

  def isCalmo(n: Int): Boolean = {
    val limite = math.sqrt(n)
    var cont = 0
    var sumD = 0
    var sumQ = 0
    var k = 0
    var q = 0
    var d = 2
    while (d < limite) {
      q = n / d
      if (n % d == 0) {
        cont += 1
        sumD += d
        sumQ += q
        if (cont == 3) {
          k += 3
          if (!isPrime(sumD)) {
            return false
          }
          if (!isPrime(sumQ)) {
            return false
          }
          cont = 0
          sumD = 0
          sumQ = 0
        }
      }
      d += 1
    }
    if (cont != 0 || k == 0) {
      return false
    }
    true
  }

  for (n <- 1 until 1000) {
    if (isCalmo(n)) {
      print(n + " ")
    }
  }
}
