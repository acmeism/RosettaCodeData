def f(n: Int, div: Int, met: String, notMet: String): String = if (n % div == 0) met else notMet
for (i <- 1 to 100) println(f(i, 15, "FizzBuzz", f(i, 3, "Fizz", f(i, 5, "Buzz", i.toString))))
