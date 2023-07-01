def properDivisors(n: Int) = (1 to n/2).filter(i => n % i == 0)
val divisorsSum = (1 to 20000).map(i => i -> properDivisors(i).sum).toMap
val result = divisorsSum.filter(v => v._1 < v._2 && divisorsSum.get(v._2) == Some(v._1))

println( result mkString ", " )
