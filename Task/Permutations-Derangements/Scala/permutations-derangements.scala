def derangements(n: Int) =
  (1 to n).permutations.filter(_.zipWithIndex.forall{case (a, b) => a - b != 1})

def subfactorial(n: Long): Long = n match {
  case 0 => 1
  case 1 => 0
  case _ => (n - 1) * (subfactorial(n - 1) + subfactorial(n - 2))
}

println(s"Derangements for n = 4")
println(derangements(4) mkString "\n")

println("\n%2s%10s%10s".format("n", "derange", "subfact"))
(0 to 9).foreach(n => println("%2d%10d%10d".format(n, derangements(n).size, subfactorial(n))))
(10 to 20).foreach(n => println(f"$n%2d${subfactorial(n)}%20d"))
