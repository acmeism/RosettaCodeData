import Text.Printf (printf)

sequence_A069654 :: [(Int,Int)]
sequence_A069654 = go 1 $ (,) <*> countDivisors <$> [1..]
 where go t ((n,c):xs) | c == t    = (t,n):go (succ t) xs
                       | otherwise = go t xs
       countDivisors n = foldr f 0 [1..floor $ sqrt $ realToFrac n]
        where f x r | n `mod` x == 0 = if n `div` x == x then r+1 else r+2
                    | otherwise      = r

main :: IO ()
main = mapM_ (uncurry $ printf "a(%2d)=%5d\n") $ take 15 sequence_A069654
