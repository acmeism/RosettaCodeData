{-# LANGUAGE LambdaCase #-}

-- Given a list of words on stdin, write to stdout the set of words having the
-- greatest number of distinct, English consonants.  In any given word, each
-- consonant may appear only once.  We consider Y to always be a consonant.

import Data.Bifunctor (first)
import Data.Char (toUpper)
import Data.Function (on)
import Data.List ((\\), groupBy, intersect, nub, sortOn)
import Data.Ord (Down(..))

-- The consonants.
consonants :: String
consonants = cons ++ map toUpper cons
  where cons = ['a'..'z'] \\ "aeiou"

-- Only the consonants in the argument.
onlyConsonants :: String -> String
onlyConsonants = (`intersect` consonants)

-- The list of all strings having the greatest number of distinct consonants.
mostDistinctConsonants :: [String] -> [String]
mostDistinctConsonants = map snd
                       . head'
                       . groupBy ((==) `on` fst)
                       . sortOn (Down . fst)
                       . map (first length)
                       . filter (allDistinct . fst)
                       . map (\s -> (onlyConsonants s, s))
  where head' = \case { [] -> []; (xs:_) -> xs; }
        allDistinct s = s == nub s

main :: IO ()
main = interact (unlines . mostDistinctConsonants . filter longEnough . words)
  where longEnough xs = length xs > 10
