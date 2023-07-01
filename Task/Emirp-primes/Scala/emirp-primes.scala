def isEmirp( v:Long ) : Boolean = {
 val b = BigInt(v.toLong)
 val r = BigInt(v.toString.reverse.toLong)
 b != r && b.isProbablePrime(16) && r.isProbablePrime(16)
}

// Generate the output
{
  val (a,b1,b2,c) = (20,7700,8000,10000)
  println( "%32s".format(          "First %d emirps: ".format( a )) + Stream.from(2).filter( isEmirp(_) ).take(a).toList.mkString(",") )
  println( "%32s".format( "Emirps between %d and %d: ".format( b1, b2 )) + {for( i <- b1 to b2 if( isEmirp(i) ) ) yield i}.mkString(",") )
  println( "%32s".format(                "%,d emirp: ".format( c )) + Iterator.from(2).filter( isEmirp(_) ).drop(c-1).next )
}
