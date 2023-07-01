import Control.Monad ((<=<))
import Data.Bifunctor (first)
import Data.List (foldl') -- '
import qualified Data.Map as M
import Data.Maybe (fromMaybe)

-------------------- VALID ISIN STRING -------------------

validISIN :: String -> Bool
validISIN =
  (&&) . isinPattern
    <*> luhn . (show <=< stringInts)

isinPattern :: String -> Bool
isinPattern s =
  12 == length s
    && all (`elem` capitals) l
    && all (`elem` (capitals <> digits)) m
    && head r `elem` digits
  where
    [l, m, r] = bites s [2, 9, 1]

luhn :: String -> Bool
luhn x = 0 == rem (s1 + s2) 10
  where
    odds = [(: []), const []]
    evens = reverse odds
    stream f =
      concat $
        zipWith ($) (cycle f) (stringInts $ reverse x)
    s1 = sum (stream odds)
    s2 =
      sum $
        sum . stringInts . show . (2 *) <$> stream evens

charMap :: M.Map Char Int
charMap = M.fromList $ zip (digits <> capitals) [0 ..]

stringInts :: String -> [Int]
stringInts = fromMaybe [] . traverse (`M.lookup` charMap)

bites :: [a] -> [Int] -> [[a]]
bites xs =
  (reverse . fst)
    . foldl' -- '
      (\(a, r) x -> first (: a) (splitAt x r))
      ([], xs)

capitals, digits :: String
capitals = ['A' .. 'Z']
digits = ['0' .. '9']

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (print . ((,) <*> validISIN))
    [ "US0378331005",
      "US0373831005",
      "U50378331005",
      "US03378331005",
      "AU0000XVGZA3",
      "AU0000VXGZA3",
      "FR0000988040"
    ]
