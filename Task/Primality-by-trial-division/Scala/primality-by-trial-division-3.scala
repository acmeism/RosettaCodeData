  def isPrime(n: Int) = {
    @tailrec
    def inner(n: Int, k: Int): Boolean = {
      if (k * k > n) true
      else if (n % k != 0) inner(n, k + 2) else false
    }

    assume(n <= Int.MaxValue - 1)
    n > 1 && ((n % 2 != 0) || (n == 2)) && inner(n, 3)
  }
