--for obvious theoretical reasons the smallest divisor of a number bare 1
--must be prime
primeFactors :: Int -> [Int]
primeFactors n = snd $ until ( (== 1) . fst ) step (n , [] )
 where
  step :: (Int , [Int] ) -> (Int , [Int] )
  step (n , li) = ( div n h , li ++ [h] )
   where
    h :: Int
    h = head $ tail $ divisors n --leave out 1

divisors :: Int -> [Int]
divisors n = [d | d <- [1 .. n] , mod n d == 0]

isGiuga :: Int -> Bool
isGiuga n = (divisors n /= [1,n]) && all (\i -> mod ( div n i - 1 ) i == 0 )
 (primeFactors n)

solution :: [Int]
solution = take 4 $ filter isGiuga [2..]
