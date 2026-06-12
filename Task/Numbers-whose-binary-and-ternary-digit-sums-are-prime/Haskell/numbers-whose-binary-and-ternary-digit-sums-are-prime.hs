import Data.Bifunctor (first)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (isPrime)

--------- BINARY AND TERNARY DIGIT SUMS BOTH PRIME -------

digitSumsPrime :: Int -> [Int] -> Bool
digitSumsPrime n = all (isPrime . digitSum n)

digitSum :: Int -> Int -> Int
digitSum n base = go n
  where
    go 0 = 0
    go n = uncurry (+) (first go $ quotRem n base)

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    show (length xs)
      <> " matches in [1..199]\n\n"
      <> table xs
  where
    xs =
      [1 .. 199]
        >>= \x -> [show x | digitSumsPrime x [2, 3]]

------------------------- DISPLAY -----------------------

table :: [String] -> String
table xs =
  let w = length (last xs)
   in unlines $
        unwords
          <$> chunksOf
            10
            (justifyRight w ' ' <$> xs)

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
