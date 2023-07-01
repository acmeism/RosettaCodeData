def adjustResult(result: IndexedSeq[Int]) = (
  result
  .map(_ % 10)        // remove carry from each digit
  .tail               // drop the seed carry
  .reverse            // put most significant digits on the left
  .dropWhile(_ == 0)  // remove leading zeroes
  .mkString
)

def addNums(x: String, y: String) = {
  val padSize = (x.length max y.length) + 1 // We want to keep a zero to the left, to catch the carry
  val paddedX = "0" * (padSize - x.length) + x
  val paddedY = "0" * (padSize - y.length) + y
  adjustResult((paddedX zip paddedY).scanRight(0) {
    case ((dx, dy), last) => dx.asDigit + dy.asDigit + last / 10
  })
}

def multByDigit(num: String, digit: Int) = adjustResult(("0"+num).scanRight(0)(_.asDigit * digit + _ / 10))

def mult(x: String, y: String) =
  y.foldLeft("")((acc, digit) => addNums(acc + "0", multByDigit(x, digit.asDigit)))
