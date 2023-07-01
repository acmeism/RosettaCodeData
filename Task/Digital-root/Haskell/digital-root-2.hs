import Data.Tuple (swap)
import Data.Maybe (fromJust)
import Data.List (elemIndex, unfoldr)
import Numeric (readInt, showIntAtBase)

-- Return a pair consisting of the additive persistence and digital root of a
-- base b number.
digRoot :: Integer -> Integer -> (Integer, Integer)
digRoot b = find . zip [0 ..] . iterate (sum . toDigits b)
  where
    find = head . dropWhile ((>= b) . snd)

-- Print the additive persistence and digital root of a base b number (given as
-- a string).
printDigRoot :: Integer -> String -> IO ()
printDigRoot b s = do
  let (p, r) = digRoot b $ strToInt b s
  (putStrLn . unwords)
    [s, "-> additive persistence:", show p, "digital root:", intToStr b r]

--
-- Utility methods for dealing with numbers in different bases.
--
-- Convert a base b number to a list of digits, from least to most significant.
toDigits
  :: Integral a
  => a -> a -> [a]
toDigits b = unfoldr f
  where
    f 0 = Nothing
    f n = Just (swap (quotRem n b))

-- A list of digits, for bases up to 36.
digits :: String
digits = ['0' .. '9'] ++ ['A' .. 'Z']

-- Return a number's base b string representation.
intToStr
  :: (Integral a, Show a)
  => a -> a -> String
intToStr b n
  | b < 2 || b > 36 = error "intToStr: base must be in [2..36]"
  | otherwise = showIntAtBase b (digits !!) n ""

-- Return the number for the base b string representation.
strToInt
  :: Integral a
  => a -> String -> a
strToInt b =
  fst . head . readInt b (`elem` digits) (fromJust . (`elemIndex` digits))

main :: IO ()
main =
  mapM_
    (uncurry printDigRoot)
    [ (2, "1001100111011110")
    , (3, "2000000220")
    , (8, "5566623376301")
    , (10, "39390")
    , (16, "99DE")
    , (36, "50YE8N29")
    , (36, "37C71GOYNYJ25M3JTQQVR0FXUK0W9QM71C1LVN")
    ]
