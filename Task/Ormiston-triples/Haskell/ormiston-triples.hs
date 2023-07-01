import Data.Numbers.Primes (primes)
import Data.List (sort)


--------------------- ORMISTON TRIPLES -------------------

ormistons :: [(Integer, Integer, Integer)]
ormistons =
  concat $ zipWith3
    (\(dx, x) (dy, y) (dz, z)
        -> [(x, y, z) | dx == dy && dx == dz])
    primeDigits
    (tail primeDigits)
    (drop 2 primeDigits)


primeDigits :: [(Integer, Integer)]
primeDigits = ((,) =<< read . sort . show) <$> primes


--------------------------- TEST -------------------------
main :: IO ()
main = do
   putStrLn "First 25 Ormistons:"
   mapM_ print $ take 25 ormistons

   putStrLn "\nCount of Ormistons up to 10^8:"
   let limit = 10^8
   print $ length $
     takeWhile (\(_, _, c) -> c <= limit) ormistons
