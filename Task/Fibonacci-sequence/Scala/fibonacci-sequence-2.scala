lazy val fib: Stream[Int] = 0 #:: 1 #:: fib.zip(fib.tail).map{case (a,b) => a + b}
