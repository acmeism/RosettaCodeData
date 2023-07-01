noDivsBy factors n = foldr (\f r-> f*f>n || ((rem n f /= 0) && r)) True factors

-- primeNums = filter (noDivsBy [2..]) [2..]
--           = 2 : filter (noDivsBy [3,5..]) [3,5..]
primeNums = 2 : 3 : filter (noDivsBy $ tail primeNums) [5,7..]

isPrime n = n > 1 && noDivsBy primeNums n
