def fizzBuzzTerm(n: Int): String | Int = // union types
  (n % 3, n % 5) match // optional semantic indentation; no braces
    case (0, 0) => "FizzBuzz"
    case (0, _) => "Fizz"
    case (_, 0) => "Buzz"
    case _      => n // no need for `.toString`, thanks to union type
  end match // optional `end` keyword, with what it's ending
end fizzBuzzTerm // `end` also usable for identifiers

val fizzBuzz = // no namespace object is required; all top level
  LazyList.from(1).map(fizzBuzzTerm)

@main def run(): Unit = // @main for main method; can take custom args
  fizzBuzz.take(100).foreach(println)
