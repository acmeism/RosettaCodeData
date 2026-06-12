module MostFrequentK
   where
import Data.List ( nub , sortBy )
import qualified Data.Set as S

count :: Eq a => [a] -> a -> Int
count [] x = 0
count ( x:xs ) k
   |x == k = 1 + count xs k
   |otherwise = count xs k

orderedStatistics :: String -> [(Char , Int)]
orderedStatistics s = sortBy myCriterion $ nub $ zip s ( map (\c -> count s c ) s )
   where
      myCriterion :: (Char , Int) -> (Char , Int) -> Ordering
      myCriterion (c1 , n1) (c2, n2)
	 |n1 > n2 = LT
	 |n1 < n2 = GT
	 |n1 == n2 = compare ( found c1 s ) ( found c2 s )
      found :: Char -> String -> Int
      found e s = length $ takeWhile (/= e ) s

mostFreqKHashing :: String -> Int -> String
mostFreqKHashing s n = foldl ((++)) [] $ map toString $ take n $ orderedStatistics s
   where
      toString :: (Char , Int) -> String
      toString ( c , i ) = c : show i

mostFreqKSimilarity :: String -> String -> Int
mostFreqKSimilarity s t = snd $ head $ S.toList $ S.fromList ( doublets s ) `S.intersection`
                           S.fromList ( doublets t )
   where
      toPair :: String -> (Char , Int)
      toPair s = ( head s , fromEnum ( head $ tail s ) - 48 )
      doublets :: String -> [(Char , Int)]
      doublets str = map toPair [take 2 $ drop start str | start <- [0 , 2 ..length str - 2]]

mostFreqKSDF :: String -> String -> Int ->Int
mostFreqKSDF s t n = mostFreqKSimilarity ( mostFreqKHashing s n ) (mostFreqKHashing t n )
