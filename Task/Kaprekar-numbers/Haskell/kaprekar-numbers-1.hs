import Numeric
import Text.Printf
import Data.Maybe (mapMaybe)

kaprekars base top = (1,0,1) : mapMaybe kap (filter res [2..top])
	where
	res x = x * (x - 1) `mod` (base - 1) == 0
	kap n = getSplit $ takeWhile (<=nn) $ dropWhile (<n)
			$ iterate (* toInteger base) 1
		where
		nn = n * n
		getSplit [] = Nothing
		getSplit (p:ps)
			| p == n = Nothing
			| q + r == n = Just (n, q, r)
			| r > n = Nothing
			| otherwise = getSplit ps
			where
			(q,r) = nn `divMod` p

heading :: Int -> String
heading = printf (h ++ d) where
	h = " #    Value (base 10)         Sum (base %d)             Square\n"
	d = " -    ---------------         -------------             ------"

printKap :: Integer -> (Int,(Integer,Integer,Integer)) -> String
printKap b (i,(n,l,r)) = printf "%2d %13s %26s %16s" i (show n) ss (base b (n*n))
	where
        ss = base b n ++ " = " ++ base b l ++ " + " ++ base b r
        base b n = showIntAtBase b (("0123456789" ++ ['a'..'z']) !!) n ""

main = do
	putStrLn $ heading 10
	mapM_ (putStrLn . printKap 10) $ zip [1..] (kaprekars 10 1000000)
	putStrLn ""
	putStrLn $ heading 17
	mapM_ (putStrLn . printKap 17) $ zip [1..] (kaprekars 17 1000000)
