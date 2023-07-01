def mkSparks( numStr:String ) : String =
  numStr.split( "[\\s,]+" ).map(_.toFloat) match {
    case v if v.isEmpty => ""
    case v if v.length == 1 => "\u2581"
    case v =>
      (for( i <- v;
            s = "\u2581\u2582\u2583\u2584\u2585\u2586\u2587\u2588".toCharArray;
            d = (v.max - v.min) / (s.length - 1)
       ) yield s( ((i - v.min) / d).toInt)).mkString
  }

println( mkSparks( "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1" ) )
println( mkSparks( "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5" ) )

// A random test...
println( mkSparks( Stream.continually( math.abs(util.Random.nextInt % 8)).take(64).mkString(" ") ))
