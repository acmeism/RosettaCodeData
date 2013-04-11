  def luhnTest(number: String): Boolean = {
    val digits = number.reverse.map { _.toString.toInt }
    val s = digits.grouped(2) map { t => t(0) +
        (if (t.length > 1) (t(1) * 2) % 10 + t(1) / 5 else 0)
    }
    s.sum % 10 == 0
  }
