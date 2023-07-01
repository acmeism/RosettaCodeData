import qualified Data.Set as S
import Data.List.Split ( chunksOf )

divisors :: Int -> [Int]
divisors n = [d | d <- [2 .. n] , mod n d == 0]

--for obvious theoretical reasons the smallest divisor of a number bare 1
--must be prime
primeFactors :: Int -> [Int]
primeFactors n = snd $ until ( (== 1) . fst ) step (n , [] )
 where
  step :: (Int , [Int] ) -> (Int , [Int] )
  step (n , li) = ( div n h , li ++ [h] )
   where
    h :: Int
    h = head $ divisors n

primeDivisors :: Int -> [Int]
primeDivisors n = S.toList $ S.fromList $ primeFactors n

solution :: (Int -> [Int] ) -> [Int]
solution f = snd $ until ( (== 30 ) . length . snd ) step ([2 , 3] , [] )
 where
  step :: ([Int] , [Int] ) -> ([Int] , [Int])
  step ( neighbours , ranums ) =  ( map ( + 1 ) neighbours , if (sum $ f
   $ head neighbours ) == (sum $ f $ last neighbours) then
   ranums ++ [ head neighbours ] else ranums )

formatNumber :: Int -> String -> String
formatNumber width num
   |width > l = replicate ( width -l ) ' ' ++ num
   |width == l = num
   |width < l = num
    where
     l = length num

main :: IO ( )
main = do
   let ruth_aaron_pairs = solution primeFactors
       maxlen = length $ show $ last ruth_aaron_pairs
       numberlines = chunksOf 8 $ map show ruth_aaron_pairs
       ruth_aaron_divisors = solution primeDivisors
       maxlen2 = length $ show $ last ruth_aaron_divisors
       numberlines2 = chunksOf 8 $ map show ruth_aaron_divisors
       putStrLn "First 30 Ruth-Aaaron numbers ( factors ) :"
   mapM_ (\nlin -> putStrLn $ foldl1 ( ++ ) $ map (\st -> formatNumber (maxlen + 2) st )
    nlin ) numberlines
   putStrLn " "
   putStrLn "First 30 Ruth-Aaron numbers( divisors ):"
   mapM_ (\nlin -> putStrLn $ foldl1 ( ++ ) $ map (\st -> formatNumber (maxlen2 + 2) st )
    nlin ) numberlines2
