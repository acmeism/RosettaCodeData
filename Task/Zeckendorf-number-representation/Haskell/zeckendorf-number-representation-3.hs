import Numeric

fib = 1 : 1 : zipWith (+) fib (tail fib)
pow2 = iterate (2*) 1

zeckendorf = map b z where
	z = 0:concat (zipWith f fib pow2)
	f x y = map (y+) (take x z)
	b x = showIntAtBase 2 ("01"!!) x ""

main = mapM putStrLn $ take 21 zeckendorf
