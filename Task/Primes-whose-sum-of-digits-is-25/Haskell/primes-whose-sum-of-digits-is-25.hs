import Data.Bifunctor (second)
import Data.List (replicate)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primes)

--------- PRIMES WITH DECIMAL DIGITS SUMMING TO 25 -------

matchingPrimes :: [Int]
matchingPrimes =
  takeWhile
    (< 5000)
    [n | n <- primes, 25 == decimalDigitSum n]

decimalDigitSum :: Int -> Int
decimalDigitSum n =
  snd $
    until
      ((0 ==) . fst)
      (\(n, x) -> second (+ x) $ quotRem n 10)
      (n, 0)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let w = length (show (last matchingPrimes))
  mapM_ putStrLn $
    ( show (length matchingPrimes)
        <> " primes (< 5000) with decimal digits totalling 25:\n"
    ) :
    ( unwords
        <$> chunksOf
          4
          (justifyRight w ' ' . show <$> matchingPrimes)
    )

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
