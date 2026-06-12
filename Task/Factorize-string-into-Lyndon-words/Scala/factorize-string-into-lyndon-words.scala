object ChenFoxLyndonFactorization extends App {
  def chenFoxLyndonFactorization(s: String): List[String] = {
    val n = s.length
    var i = 0
    var factorization = List[String]()
    while (i < n) {
      var j = i + 1
      var k = i
      while (j < n && s.charAt(k) <= s.charAt(j)) {
        if (s.charAt(k) < s.charAt(j)) {
          k = i
        } else {
          k += 1
        }
        j += 1
      }
      while (i <= k) {
        factorization = factorization :+ s.substring(i, i + j - k)
        i += j - k
      }
    }
    assert(s == factorization.mkString)
    factorization
  }

  var m = "0"
  for (i <- 0 until 7) {
    val m0 = m
    m = m.replace('0', 'a').replace('1', '0').replace('a', '1')
    m = m0 + m
  }

  println(chenFoxLyndonFactorization(m))
}
