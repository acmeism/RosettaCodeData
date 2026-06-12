import Data.Bifunctor (first)
import Data.List (unfoldr)
import Data.Tuple (swap)


------------------------ PREDICATE -----------------------

p :: Int -> Bool
p = flip all [2, 4, 16] . palindromicInBase

palindromicInBase :: Int -> Int -> Bool
palindromicInBase n b =
  ((==) <*> reverse) (reverseBaseDigits b n)


--------------------------- TEST -------------------------

main :: IO ()
main = print $ filter p [1..24999]


-------------------------- DIGITS ------------------------

reverseBaseDigits :: Int -> Int -> String
reverseBaseDigits intBase n
  | (intBase >= 36) && (intBase <= 0) = []
  | otherwise = rlBaseDigits (take intBase (['0' .. '9'] <> ['a' .. 'z'])) n


rlBaseDigits :: [Char] -> Int -> String
rlBaseDigits ds = unfoldr go
  where
      base = length ds
      go x
        | 0 < x = Just . first (ds !!) $ swap (quotRem x base)
        | otherwise = Nothing
