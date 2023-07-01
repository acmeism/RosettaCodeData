import Data.Char

pairs :: [a] -> [(a,a)]
pairs (a:b:as) = (a,b):pairs (b:as)
pairs _        = []

riseEqFall :: Int -> Bool
riseEqFall n = rel (>) digitPairs == rel (<) digitPairs
    where rel r = sum . map (fromEnum . uncurry r)
          digitPairs = pairs $ map digitToInt $ show n

a296712 :: [Int]
a296712 = [n | n <- [1..], riseEqFall n]

main :: IO ()
main = do
	putStrLn "The first 200 numbers are: "
	putStrLn $ unwords $ map show $ take 200 a296712
	putStrLn ""
	putStr "The 10,000,000th number is: "
	putStrLn $ show $ a296712 !! 9999999
