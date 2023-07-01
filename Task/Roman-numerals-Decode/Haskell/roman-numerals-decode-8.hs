import qualified Data.Map.Strict as M (Map, fromList, lookup)
import Data.Maybe (isNothing, isJust, fromJust, catMaybes)
import Data.List (mapAccumL)

mapRoman :: M.Map String Int
mapRoman =
  M.fromList
    [ ("M", 1000)
    , ("CM", 900)
    , ("D", 500)
    , ("CD", 400)
    , ("C", 100)
    , ("XC", 90)
    , ("L", 50)
    , ("XL", 40)
    , ("X", 10)
    , ("IX", 9)
    , ("V", 5)
    , ("IV", 4)
    , ("I", 1)
    ]

fromRoman :: String -> Int
fromRoman s =
  let value k = M.lookup k mapRoman
  in sum . catMaybes . snd $
     mapAccumL
       (\mi (l, r, i) ->
           let mValue = value [l, r] -- mapRoman lookup of [left, right] Chars
               (lastPair, pairValue)
                 | isJust mValue = (Just i, mValue) -- Pair match: index updated
                 | isNothing mi || i - fromJust mi > 1 = (mi, value [l])
                 | otherwise = (mi, Nothing) -- Left Char was counted in pair
           in (lastPair, pairValue))
       Nothing -- Accumulator – maybe Index to last matched Char pair
       (zip3 s (tail s ++ " ") [0 ..]) -- Indexed character pairs

main :: IO ()
main = print $ fromRoman <$> ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"]
