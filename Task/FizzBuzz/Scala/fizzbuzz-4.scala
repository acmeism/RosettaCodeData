for (n <- 1 to 100) println(List((15, "FizzBuzz"), (3, "Fizz"), (5, "Buzz")).find(t => n % t._1 == 0).getOrElse((0, n.toString))._2)
