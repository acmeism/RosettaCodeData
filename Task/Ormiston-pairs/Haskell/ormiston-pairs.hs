import Data.List (sort)
import Data.Numbers.Primes (primes)

---------------------- ORMISTON PAIRS --------------------

ormistonPairs :: [(Int, Int)]
ormistonPairs =
  [ (fst a, fst b)
    | (a, b) <- zip primeDigits (tail primeDigits),
      snd a == snd b
  ]

primeDigits :: [(Int, String)]
primeDigits = (,) <*> (sort . show) <$> primes

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn "First 30 Ormiston pairs:"
    >> mapM_ print (take 30 ormistonPairs)
    >> putStrLn "\nCount of Ormistons up to 1,000,000:"
    >> print (length (takeWhile ((<= 1000000) . snd) ormistonPairs))
