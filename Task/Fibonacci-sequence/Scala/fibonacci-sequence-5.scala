val it = Iterator.iterate((0,1)){case (a,b) => (b,a+b)}.map(_._1)
//example:
println(it.take(13).mkString(",")) //prints: 0,1,1,2,3,5,8,13,21,34,55,89,144
