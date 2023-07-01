{-# LANGUAGE OverloadedStrings #-}

import Data.List as L (filter, groupBy, head, length, sortOn)
import Data.Map.Strict as M (Map, fromList, keys, lookup)
import Data.Text as T (Text, splitOn, words)
import Data.Maybe (fromJust)
import Data.Ord (comparing)
import Data.Function (on)
import Data.Tuple (swap)
import Data.Bool (bool)

data DatePart
  = Month
  | Day

type M = Text

type D = Text

main :: IO ()
main =
  print $
  -- The month with only one remaining day,
  --
  -- (A's month contains only one remaining day)
  -- (3 :: A "Then I also know")
  uniquePairing Month $
  -- among the days with unique months,
  --
  -- (B's day is paired with only one remaining month)
  -- (2 :: B "I know now")
  uniquePairing Day $
  -- excluding months with unique days,
  --
  -- (A's month is not among those with unique days)
  -- (1 :: A "I know that Bernard does not know")
  monthsWithUniqueDays False $
  -- from the given month-day pairs:
  --
  -- (0 :: Cheryl's list)
  (\(x:y:_) -> (x, y)) . T.words <$>
  splitOn
    ", "
    "May 15, May 16, May 19, June 17, June 18, \
              \July 14, July 16, Aug 14, Aug 15, Aug 17"

----------------------QUERY FUNCTIONS----------------------
monthsWithUniqueDays :: Bool -> [(M, D)] -> [(M, D)]
monthsWithUniqueDays bln xs =
  let months = fst <$> uniquePairing Day xs
  in L.filter (bool not id bln . (`elem` months) . fst) xs

uniquePairing :: DatePart -> [(M, D)] -> [(M, D)]
uniquePairing dp xs =
  let f =
        case dp of
          Month -> fst
          Day -> snd
  in (\md ->
         let dct = f md
             uniques =
               L.filter
                 ((1 ==) . L.length . fromJust . flip M.lookup dct)
                 (keys dct)
         in L.filter ((`elem` uniques) . f) xs)
       ((((,) . mapFromPairs) <*> mapFromPairs . fmap swap) xs)

mapFromPairs :: [(M, D)] -> Map Text [Text]
mapFromPairs xs =
  M.fromList $
  ((,) . fst . L.head) <*> fmap snd <$>
  L.groupBy (on (==) fst) (L.sortOn fst xs)
