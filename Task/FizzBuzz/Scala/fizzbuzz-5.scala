def fizzBuzzTerm(n: Int): String =
  if (n % 15 == 0) "FizzBuzz"
  else if (n % 3 == 0) "Fizz"
  else if (n % 5 == 0) "Buzz"
  else n.toString

def fizzBuzz(): Unit = LazyList.from(1).take(100).map(fizzBuzzTerm).foreach(println)
