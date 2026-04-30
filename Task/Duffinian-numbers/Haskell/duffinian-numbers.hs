import Data.List ( tail )
import qualified Data.Set as S
import Data.List.Split ( divvy )

divisors :: Int -> [Int]
divisors n = [d | d <- [1..n] , mod n d == 0]

primeFactors :: Int -> [Int]
primeFactors n = snd $ until ( (== 1 ) . fst ) step (n , [] )
   where
      step :: (Int , [Int]) -> (Int , [Int])
      step ( aNumber , factors ) = ( div aNumber smallest , factors ++
        [smallest] )
        where
          smallest :: Int
          smallest = head $ tail $ divisors aNumber

isRelativelyPrime :: Int -> Int -> Bool
isRelativelyPrime a b = S.null $ S.intersection ( S.fromList $
 primeFactors a ) ( S.fromList $ primeFactors b )

isDuffinian :: Int -> Bool
isDuffinian n = and [(length $ primeFactors n ) > 1 , isRelativelyPrime
 ( sum $ divisors n ) n]

solution :: [Int]
solution = take 50 $ filter isDuffinian [1..]

findTriplets :: [[Int]]
findTriplets = take 15 $ filter condition $ divvy 3 1 $ filter
 isDuffinian [1..]
  where
   condition :: [Int] -> Bool
   condition [a , b , c] = b == a + 1 && c == b + 1

outputTriplet :: [Int] -> String
outputTriplet [a , b , c] = "(" ++ replicate ( 6 - length sa ) ' ' ++
 sa ++ replicate (6 - length sb) ' ' ++ sb ++ replicate (6 - length sc )
 ' ' ++ sc ++ "   )"
   where
      sa = show a
      sb = show b
      sc = show c

main :: IO ( )
main = do
   putStrLn "The first 50 Duffinian numbers are :"
   print solution
   putStrLn "The first 15 Duffinian triplets are:"
   mapM_ (\t -> putStrLn $ outputTriplet t ) findTriplets
