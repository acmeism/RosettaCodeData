object Sailors extends App {
  var x = 0

  private def valid(n: Int, _nuts: Int): Boolean = {
    var nuts = _nuts
    for (k <- n until 0 by -1) {
      if (nuts % n != 1) return false
      nuts -= 1 + nuts / n
    }
    nuts != 0 && (nuts % n == 0)
  }

  for (nSailors <- 2 until 10) {
    while (!valid(nSailors, x)) x += 1
    println(f"$nSailors%d: $x%d")
  }

}
