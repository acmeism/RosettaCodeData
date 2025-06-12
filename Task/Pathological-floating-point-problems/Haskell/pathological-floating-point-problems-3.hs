import Data.Ratio ((%), numerator, denominator)
import Data.List (genericIndex)

balances :: [Rational]
balances = e - 1 : zipWith nextYear [1..] balances
  where
    nextYear n b = n * b - 1

    e = brothersFormulae 1000


factorial :: [Integer]
factorial = 0 : 1 : zipWith (*) (drop 1 factorial) [2..]

-- >>> take 10 factorial
-- [0,1,2,6,24,120,720,5040,40320,362880]

brothersFormulae :: Integer -> Rational
brothersFormulae n = sum $ map step [0..n]
  where
    step i = (2 * i + 2) % genericIndex factorial  (2 * i + 1)

task2 :: String
task2 = showRational 30 . (balances !!) $ 25

-- >>> task2
-- "+0.039938729673230208903671455210"

main :: IO ()
main = putStrLn task2
