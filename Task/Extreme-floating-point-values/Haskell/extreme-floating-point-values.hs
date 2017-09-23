main = do
let inf = 1/0
let minus_inf = -1/0
let minus_zero = -1/inf
let nan = 0/0

putStrLn ("Positive infinity = "++(show inf))
putStrLn ("Negative infinity = "++(show minus_inf))
putStrLn ("Negative zero = "++(show minus_zero))
putStrLn ("Not a number = "++(show nan))

--Some Arithmetic

putStrLn ("inf + 2.0 = "++(show (inf+2.0)))
putStrLn ("inf - 10 = "++(show (inf-10)))
putStrLn ("inf - inf = "++(show (inf-inf)))
putStrLn ("inf * 0 = "++(show (inf * 0)))
putStrLn ("nan + 1.0= "++(show (nan+1.0)))
putStrLn ("nan + nan = "++(show (nan + nan)))

--Some Comparisons

putStrLn ("nan == nan = "++(show (nan == nan)))
putStrLn ("0.0 == - 0.0 = "++(show (0.0 == minus_zero)))
putStrLn ("inf == inf = "++(show (inf == inf)))
