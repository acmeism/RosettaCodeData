object Main {

  // This is a special class for memoization
  case class Memo[A,B](f: A => B) extends (A => B) {
	  private val cache = Map.empty[A, B]
	  def apply(x: A) = cache getOrElseUpdate (x, f(x))
  }

  // Naive, but memoized solution
  lazy val namesStartingMemo : Memo[Tuple2[Int, Int], BigInt] = Memo {
    case (1, 1) => 1
    case (a, n) =>
	    if (a > n/2) namesStartingMemo(a - 1, n - 1)
	    else if (n < a) 0
	    else if (n == a) 1
	    else (1 to a).map(i => namesStartingMemo(i, n - a)).sum

  }

  def partitions(n: Int) = (1 to n).map(namesStartingMemo(_, n)).sum

  // main method
  def main(args: Array[String]): Unit = {
    for (i <- 1 to 25) {
    	for (j <- 1 to i) {
	      print(namesStartingMemo(j, i));
	      print(' ');
	    }
    	println()
    }
    println(partitions(23))
    println(partitions(123))
    println(partitions(1234))
    println(partitions(12345))
  }
}
