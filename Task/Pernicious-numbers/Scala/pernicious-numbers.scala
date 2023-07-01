def isPernicious( v:Long ) : Boolean = BigInt(v.toBinaryString.toList.filter( _ == '1' ).length).isProbablePrime(16)

// Generate the output
{
  val (a,b1,b2) = (25,888888877L,888888888L)
  println( Stream.from(2).filter( isPernicious(_) ).take(a).toList.mkString(",") )
  println( {for( i <- b1 to b2 if( isPernicious(i) ) ) yield i}.mkString(",") )
}
