class PrimeFactors[N](n: N)(implicit num: Integral[N]) extends Iterator[N] {
  import num._
  val two = one + one
  var currentN = n
  var divisor = two

  def next = {
    if (!hasNext)
      throw new NoSuchElementException("next on empty iterator")

    while(currentN % divisor != zero) {
      if (divisor == two)
        divisor += one
      else
        divisor += two

      if (divisor * divisor > currentN)
        divisor = currentN
    }
    currentN /= divisor
    divisor
  }

  def hasNext = currentN != one && currentN > zero
}
