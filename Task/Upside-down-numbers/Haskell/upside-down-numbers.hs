import Data.Char ( digitToInt )
import Data.List ( unfoldr , (!!) )

findLimits :: (Int , Int) -> [(Int , Int)]
findLimits (st , end ) = unfoldr(\(x , y ) -> if x > y then Nothing else
 Just ((x , y ) , (x + 1 , y - 1 ))) (st , end )

isUpsideDown :: Int -> Bool
isUpsideDown n
   |elem '0' str = False
   |otherwise = all (\(a , b ) -> digitToInt( str !! a ) + digitToInt ( str !!
     b ) == 10 ) $ findLimits ( 0 , length str - 1 )
   where
    str = show n

main :: IO ( )
main = do
   let upsideDowns = take 5000 $ filter isUpsideDown [1..]
   putStrLn "The first fifty upside-down numbers!"
   print $ take 50 upsideDowns
   putStr "The five hundredth such number : "
   print $ upsideDowns !! 499
   putStr "The five thousandth such number : "
   print $ last upsideDowns
