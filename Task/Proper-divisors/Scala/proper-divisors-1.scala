def properDivisors(n: Int) = (1 to n/2).filter(i => n % i == 0)
def format(i: Int, divisors: Seq[Int]) = f"$i%5d    ${divisors.length}%2d   ${divisors mkString " "}"

println(f"    n   cnt   PROPER DIVISORS")
val (count, list) = (1 to 20000).foldLeft( (0, List[Int]()) ) { (max, i) =>
    val divisors = properDivisors(i)
    if (i <= 10 || i == 100) println( format(i, divisors) )
    if (max._1 < divisors.length) (divisors.length, List(i))
    else if (max._1 == divisors.length) (divisors.length, max._2 ::: List(i))
    else max
}

list.foreach( number => println(f"$number%5d    ${properDivisors(number).length}") )
