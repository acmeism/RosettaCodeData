println(s"Fibonacci:  ${fibStream(1,1).take(10).mkString(",")}")
println(s"Tribonacci: ${fibStream(1,1,2).take(10).mkString(",")}")
println(s"Tetranacci: ${fibStream(1,1,2,4).take(10).mkString(",")}")
println(s"Lucas:      ${fibStream(2,1).take(10).mkString(",")}")
