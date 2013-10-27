  def luhnTest1(number: String): Boolean = {
    var (odd, sum) = (true, 0)

    for (int <- number.reverse.map { _.toString.toShort }) {
      if (odd) sum += int
      else sum += (int * 2 % 10) + (int / 5)
      odd = !odd
    }
    sum % 10 == 0
  }
