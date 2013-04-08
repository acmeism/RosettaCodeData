(1 to 100) map ( x => (x % 3, x % 5) match{
    case (0,0) => "FizzBuzz"
    case (0,_) => "Fizz"
    case (_,0) => "Buzz"
    case _ => x
}) foreach println
