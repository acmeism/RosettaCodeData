import Data.Bits ((.&.))

sierpinski n = map row [m, m-1 .. 0] where
	m = 2^n - 1
	row y = replicate y ' ' ++ concatMap cell [0..m - y] where
		cell x	| y .&. x == 0 = " *"
			| otherwise = "  "

main = mapM_ putStrLn $ sierpinski 4
