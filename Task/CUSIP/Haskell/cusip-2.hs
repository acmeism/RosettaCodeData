import qualified Data.Map as M (Map, fromList, lookup)
import Data.Maybe (fromMaybe)

-------------------------- CUSIP -------------------------

cusipMap :: M.Map Char Int
cusipMap =
  M.fromList $
    zip (['0' .. '9'] <> ['A' .. 'Z'] <> "*@#") [0 ..]

cusipValid :: String -> Bool
cusipValid s =
  let ns = (fromMaybe [] . traverse (`M.lookup` cusipMap)) s
   in (9 == length ns)
        && let qrSum =
                 sum $
                   ( [quot, rem]
                       <*> zipWith
                         id
                         (cycle [id, (* 2)])
                         (take 8 ns)
                   )
                     <*> [10]
            in last ns == rem (10 - rem qrSum 10) 10

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (print . ((,) <*> cusipValid))
    [ "037833100",
      "17275R102",
      "38259P508",
      "594918104",
      "68389X106",
      "68389X105"
    ]
