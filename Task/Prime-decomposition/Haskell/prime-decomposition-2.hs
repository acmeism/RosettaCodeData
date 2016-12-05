import Data.Maybe (listToMaybe)
import Data.List (unfoldr)

factorize :: Integer -> [Integer]
factorize n
  = unfoldr (\n     -> listToMaybe [(x, div n x)      | x <- [2..n], mod n x==0]) n
  = unfoldr (\(d,n) -> listToMaybe [(x, (x, div n x)) | x <- [d..n], mod n x==0]) (2,n)
  = unfoldr (\(d,n) -> listToMaybe [(x, (x, div n x)) | x <-
                    takeWhile ((<=n).(^2)) [d..] ++ [n|n>1], mod n x==0]) (2,n)
  = unfoldr (\(ds,n) -> listToMaybe [(x, (dropWhile (< x) ds, div n x)) | n>1, x <-
                    takeWhile ((<=n).(^2)) ds ++ [n|n>1], mod n x==0]) (primesList,n)
