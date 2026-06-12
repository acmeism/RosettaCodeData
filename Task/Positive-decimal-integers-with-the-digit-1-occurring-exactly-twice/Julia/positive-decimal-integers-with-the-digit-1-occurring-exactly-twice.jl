totalddigisn(x, d = 1, n = 2; base=10) = count(j -> j == d, digits(x; base)) == n

println(filter(totalddigisn, 1:1000))
