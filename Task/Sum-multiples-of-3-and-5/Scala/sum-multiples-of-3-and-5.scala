def sum35( max:BigInt ) : BigInt = max match {

  // Simplest solution but limited to Ints only
  case j if j < 100000 => (1 until j.toInt).filter( i => i % 3 == 0 || i % 5 == 0 ).sum

  // Using a custom iterator that takes Longs
  case j if j < 10e9.toLong => {
    def stepBy( step:Long ) : Iterator[Long] = new Iterator[Long] { private var i = step; def hasNext = true; def next() : Long = { val result = i; i = i + step; result } }
    stepBy(3).takeWhile( _< j ).sum + stepBy(5).takeWhile( _< j ).sum - stepBy(15).takeWhile( _< j ).sum 	
  }

  // Using the formula for a Triangular number
  case j => {
    def triangle( i:BigInt ) = i * (i+1) / BigInt(2)
    3 * triangle( (j-1)/3 ) + 5 * triangle( (j-1)/5 ) - 15 * triangle( (j-1)/15 )
  }
}

{
for( i <- (0 to 20); n = "1"+"0"*i ) println( (" " * (21 - i)) + n + " => " + (" " * (21 - i)) + sum35(BigInt(n)) )
}
