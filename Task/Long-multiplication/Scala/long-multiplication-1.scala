def addNums(x: String, y: String) = {
  val padSize = x.length max y.length
  val paddedX = "0" * (padSize - x.length) + x
  val paddedY = "0" * (padSize - y.length) + y
  val (sum, carry) = (paddedX zip paddedY).foldRight(("", 0)) {
    case ((dx, dy), (acc, carry)) =>
      val sum = dx.asDigit + dy.asDigit + carry
      ((sum % 10).toString + acc, sum / 10)
  }
  if (carry != 0) carry.toString + sum else sum
}

def multByDigit(num: String, digit: Int) = {
  val (mult, carry) = num.foldRight(("", 0)) {
    case (d, (acc, carry)) =>
      val mult = d.asDigit * digit + carry
      ((mult % 10).toString + acc, mult / 10)
  }
  if (carry != 0) carry.toString + mult else mult
}

def mult(x: String, y: String) =
  y.foldLeft("")((acc, digit) => addNums(acc + "0", multByDigit(x, digit.asDigit)))
