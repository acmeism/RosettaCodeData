import Data.List (intercalate)
import Data.Function (on)
import Data.Bool (bool)

-- RANGE FORMAT -------------------------------------------
rangeFormat :: [Int] -> String
rangeFormat = intercalate "," . fmap rangeString . splitBy ((/=) . succ)

rangeString xs
  | 2 < length xs = x ++ '-' : last t
  | otherwise = intercalate "," ps
  where
    ps@(x:t) = show <$> xs


-- GENERIC FUNCTION ---------------------------------------

-- Split wherever a supplied predicate matches the
-- relationship between two consecutive items.
splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
splitBy _ [] = []
splitBy _ [x] = [[x]]
splitBy f xs@(_:t) = active : acc
  where
    (active, acc) =
      foldr
        (\(x, prev) (active, acc) ->
            let current = bool active [prev] (null active)
            in bool (x : current, acc) ([x], current : acc) (f x prev))
        ([], [])
        (zip xs t)

-- TEST ---------------------------------------------------
main :: IO ()
main =
  print $
  rangeFormat
    [ 0
    , 1
    , 2
    , 4
    , 6
    , 7
    , 8
    , 11
    , 12
    , 14
    , 15
    , 16
    , 17
    , 18
    , 19
    , 20
    , 21
    , 22
    , 23
    , 24
    , 25
    , 27
    , 28
    , 29
    , 30
    , 31
    , 32
    , 33
    , 35
    , 36
    , 37
    , 38
    , 39
    ]
