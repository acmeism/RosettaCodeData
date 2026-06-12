import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primes)

---------------------- HONAKER PRIMES --------------------

honakers :: [(Integer, Integer)]
honakers =
  filter
    (uncurry (==) . both sumDigits)
    (zip [1 ..] primes)

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn "First Fifty:\n"
    >> mapM_
      (putStrLn . unwords)
      ( chunksOf
          5
          (take 50 (show <$> honakers))
      )
    >> putStrLn "\n10Kth:\n"
    >> print (honakers !! pred 10000)

------------------------- GENERIC ------------------------
sumDigits :: Integer -> Integer
sumDigits = foldr ((+) . read . pure) 0 . show

both :: (a -> b) -> (a, a) -> (b, b)
both = join bimap
