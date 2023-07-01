object Disarium extends App {
  def power(base: Int, exp: Int): Int = {
    var result = 1
    for (i <- 1 to exp) {
      result *= base
    }
    return result
  }
  def is_disarium(num: Int): Boolean = {
    val digits = num.toString.split("")
    var sum = 0
    for (i <- 0 to (digits.size - 1)) {
      sum += power(digits(i).toInt, i + 1)
    }
    return num == sum
  }

  var i = 0
  var count = 0
  while (count < 19) {
    if (is_disarium(i)) {
      count += 1
      printf("%d ", i)
    }
    i += 1
  }
  println("")
}
