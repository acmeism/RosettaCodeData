import Data.List (elemIndex)
import Data.Maybe (fromJust)
import Numeric (readInt, showIntAtBase)

-- Return a pair consisting of the additive persistence and digital root of a
-- base b number.
digRoot :: Integer -> Integer -> (Integer, Integer)
digRoot b = find . zip [0..] . iterate (sum . toDigits b)
  where find = head . dropWhile ((>= b) . snd)

-- Print the additive persistence and digital root of a base b number (given as
-- a string).
printDigRoot :: Integer -> String -> IO ()
printDigRoot b s = do
  let (p, r) = digRoot b $ strToInt b s
  putStrLn $ s ++ ": additive persistence " ++ show p ++
    ", digital root " ++ intToStr b r

--
-- Utility methods for dealing with numbers in different bases.
--

-- Convert a base b number to a list of digits, from least to most significant.
toDigits :: Integral a => a -> a -> [a]
toDigits b n = toDigits' n 0
  where toDigits' 0 0 = [0]
        toDigits' 0 _ = []
        toDigits' m _ = let (q, r) = m `quotRem` b in r : toDigits' q r

-- A list of digits, for bases up to 36.
digits :: String
digits = ['0'..'9'] ++ ['A'..'Z']

-- Return a number's base b string representation.
intToStr :: Integral a => a -> a -> String
intToStr b n | b < 2 || b > 36 = error "intToStr: base must be in [2..36]"
             | otherwise = showIntAtBase b (digits !!) n ""

-- Return the number for the base b string representation.
strToInt :: Integral a => a -> String -> a
strToInt b = fst . head . readInt b (`elem` digits)
                                    (fromJust . (`elemIndex` digits))

main :: IO ()
main = do
  printDigRoot  2 "1001100111011110"
  printDigRoot  3 "2000000220"
  printDigRoot  8 "5566623376301"
  printDigRoot 10 "39390"
  printDigRoot 16 "99DE"
  printDigRoot 36 "50YE8N29"
  printDigRoot 36 "37C71GOYNYJ25M3JTQQVR0FXUK0W9QM71C1LVN"
