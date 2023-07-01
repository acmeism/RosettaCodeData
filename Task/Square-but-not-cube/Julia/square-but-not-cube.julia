iscube(n) = n == round(Int, cbrt(n))^3

println(collect(Iterators.take((n^2 for n in 1:10^6 if !iscube(n^2)), 30)))
