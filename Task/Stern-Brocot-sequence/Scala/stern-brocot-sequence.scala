lazy val sbSeq: Stream[BigInt] = {
  BigInt("1") #::
  BigInt("1") #::
  (sbSeq zip sbSeq.tail zip sbSeq.tail).
  flatMap{ case ((a,b),c) => List(a+b,c) }
}

// Show the results
{
println( s"First 15 members: ${(for( n <- 0 until 15 ) yield sbSeq(n)) mkString( "," )}" )
println
for( n <- 1 to 10; pos = sbSeq.indexOf(n) + 1 ) println( s"Position of first $n is at $pos" )
println
println( s"Position of first 100 is at ${sbSeq.indexOf(100) + 1}" )
println
println( s"Greatest Common Divisor for first 1000 members is 1: " +
  (sbSeq zip sbSeq.tail).take(1000).forall{ case (a,b) => a.gcd(b) == 1 } )
}
