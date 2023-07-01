val fac: Int => Int = Y[Int, Int](f => i => if (i <= 0) 1 else f(i - 1) * i)
fac(6)  //> res0: Int = 720

val fib: Int => Int = Y[Int, Int](f => i => if (i < 2) i else f(i - 1) + f(i - 2))
fib(6)  //> res1: Int = 8
