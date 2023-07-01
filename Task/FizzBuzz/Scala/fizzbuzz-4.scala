for (i <- 1 to 100) println(Seq(15 -> "FizzBuzz", 3 -> "Fizz", 5 -> "Buzz").find(i % _._1 == 0).map(_._2).getOrElse(i))
