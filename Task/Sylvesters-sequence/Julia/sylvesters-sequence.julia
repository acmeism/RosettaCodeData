sylvester(n) = (n == 1) ? big"2" : prod(sylvester, 1:n-1) + big"1"

foreach(n -> println(rpad(n, 3), " =>  ", sylvester(n)), 1:10)

println("Sum of reciprocals of first 10: ", sum(big"1.0" / sylvester(n) for n in 1:10))
