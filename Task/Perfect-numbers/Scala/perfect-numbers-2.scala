def perfect(n: Int) =
  (for (x <- 2 to n/2 if n % x == 0) yield x).sum + 1 == n
