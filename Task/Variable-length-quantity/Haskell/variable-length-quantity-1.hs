import Numeric

to = flip showOct ""

from = fst . head . readOct

main = do
	fancy 2097152
	fancy 2097151
		where fancy i = putStrLn $ to i ++ " <-> " ++ show (from $ to i)
