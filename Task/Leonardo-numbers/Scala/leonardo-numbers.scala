def leo( n:Int, n1:Int=1, n2:Int=1, addnum:Int=1 ) : BigInt = n match {
  case 0 => n1
  case 1 => n2
  case n => leo(n - 1, n1, n2, addnum) + leo(n - 2, n1, n2, addnum) + addnum
}

{
println( "The first 25 Leonardo Numbers:")
(0 until 25) foreach { n => print( leo(n) + " " ) }

println( "\n\nThe first 25 Fibonacci Numbers:")
(0 until 25) foreach { n => print( leo(n, n1=0, n2=1, addnum=0) + " " ) }
}
