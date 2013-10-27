base = 8

to 0 = []
to i = to (div i base) ++ [mod i base]

from = foldl1 (\x y -> x*base + y)

main = do
	fancy 2097152
	fancy 2097151
		where fancy i = putStrLn $ concatMap show (to i) ++ " <-> " ++ show (from $ to i)
