import Data.List (intercalate)
import Data.Function (on)

-- RANGE FORMAT --------------------------------------------------------------

rangeFormat :: [Int] -> String
rangeFormat = intercalate "," . (rangeString <$>) . splitBy ((/=) . succ)
  where
    rangeString xs
      | length xs > 2 = x ++ '-' : last t
      | otherwise = intercalate "," ps
      where
        ps@(x:t) = show <$> xs


-- GENERIC FUNCTION ----------------------------------------------------------

-- Split wherever a supplied predicate matches the relationship
-- between two consecutive items.

-- E.G. at boundaries between vowels and consonants:
-- splitBy (on (/=) (flip elem "aeiouAEIOU")) "Constantinople"
-- ->  ["C","o","nst","a","nt","i","n","o","pl","e"]

-- At boundaries between non-successive integers:
-- splitBy ((/=) . succ) [0, 1, 2, 4, 6, 7, 8, 11, 12, 14]
-- ->  [[0,1,2],[4],[6,7,8],[11,12],[14]]

splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
splitBy _ [] = []
splitBy _ [x] = [[x]]
splitBy f xs@(_:t) = active : acc
  where
    (active, acc) =
      foldr
        (\(x, prev) (active, acc) ->
            let current =
                  if null active
                    then [prev]
                    else active
            in if f x prev
                 then ([x], current : acc)
                 else (x : current, acc))
        ([], [])
        (zip xs t)

-- TEST ----------------------------------------------------------------------
main :: IO ()
main =
  print $
  rangeFormat
    [ 0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
     15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
     25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
     37, 38, 39]
