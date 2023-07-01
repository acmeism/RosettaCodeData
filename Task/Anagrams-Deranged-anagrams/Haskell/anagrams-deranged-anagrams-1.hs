{-# LANGUAGE TupleSections #-}

import Data.List (maximumBy, sort, unfoldr)
import Data.Ord (comparing)
import qualified Data.Map as M
import qualified Data.Set as S

-- Lists of words grouped by their "signatures".  A signature is a sorted
-- list of characters.  Duplicate words stored in sets.
groupBySig :: [String] -> [(String, S.Set String)]
groupBySig = map ((,) . sort <*> S.singleton)

-- Groups as lists of equivalent words.
equivs :: [(String, S.Set String)] -> [[String]]
equivs = map (S.toList . snd) . M.toList . M.fromListWith S.union

-- True if a pair of words differs in all character positions.
isDerangement :: (String, String) -> Bool
isDerangement (a, b) = and $ zipWith (/=) a b

-- All pairs of elements, ignoring order.
pairs :: [t] -> [(t, t)]
pairs = concat . unfoldr step
  where
    step (x:xs) = Just (map (x, ) xs, xs)
    step [] = Nothing

-- All anagram pairs in the input string.
anagrams :: [String] -> [(String, String)]
anagrams = concatMap pairs . equivs . groupBySig

-- The pair of words forming the longest deranged anagram.
maxDerangedAnagram :: [String] -> Maybe (String, String)
maxDerangedAnagram = maxByLen . filter isDerangement . anagrams
  where
    maxByLen [] = Nothing
    maxByLen xs = Just $ maximumBy (comparing (length . fst)) xs

main :: IO ()
main = do
  input <- readFile "unixdict.txt"
  case maxDerangedAnagram $ words input of
    Nothing -> putStrLn "No deranged anagrams were found."
    Just (a, b) -> putStrLn $ "Longest deranged anagrams: " <> a <> " and " <> b
