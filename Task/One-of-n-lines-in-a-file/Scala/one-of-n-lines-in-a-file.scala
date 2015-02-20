def one_of_n(n: Int, i: Int = 1, j: Int = 1): Int =
  if (n < 1) i else one_of_n(n - 1, if (scala.util.Random.nextInt(j) == 0) n else i, j + 1)

def simulate(lines: Int, iterations: Int) = {
  val counts = new Array[Int](lines)
  for (_ <- 1 to iterations; i = one_of_n(lines) - 1) counts(i) = counts(i) + 1
  counts
}

println(simulate(10, 1000000) mkString "\n")
