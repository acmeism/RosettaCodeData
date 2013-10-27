  def replaceMultiples(x: Int, rs: (Int, String)*) =
    rs map { case (n, s) => Either cond (x % n == 0, s, x) } reduceLeft ((a, b) =>
      a fold ((_ => b), (s => b fold ((_ => a), (t => Right(s + t))))))

  def fizzbuzz(n: Int) =
    replaceMultiples(n, 3 -> "Fizz", 5 -> "Buzz") fold ((_ toString), identity)

  1 to 100 map fizzbuzz foreach println
