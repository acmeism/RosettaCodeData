import Data.List (find, findIndex, nub)
import Data.Maybe (fromJust)
import Data.Set (Set, fromList, insert, isSubsetOf, member)

--- INFINITE STREAM OF RECAMAN SERIES OF GROWING LENGTH --
rSeries :: [[Int]]
rSeries =
  scanl
    ( \rs@(r : _) i ->
        let back = r - i
            nxt
              | 0 > back || elem back rs = r + i
              | otherwise = back
         in nxt : rs
    )
    [0]
    [1 ..]

----------- INFINITE STREAM OF RECAMAN-GENERATED ---------
--------------- INTEGER SETS OF GROWING SIZE -------------
rSets :: [(Set Int, Int)]
rSets =
  scanl
    ( \(seen, r) i ->
        let back = r - i
            nxt
              | 0 > back || member back seen = r + i
              | otherwise = back
         in (insert nxt seen, nxt)
    )
    (fromList [0], 0)
    [1 ..]

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let setK = fromList [0 .. 1000]
  (putStrLn . unlines)
    [ "First 15 Recamans:",
      show . reverse . fromJust $ find ((15 ==) . length) rSeries,
      [],
      "First duplicated Recaman:",
      show . head . fromJust $ find ((/=) <$> length <*> (length . nub)) rSeries,
      [],
      "Length of Recaman series required to include [0..1000]:",
      show . fromJust $ findIndex (\(setR, _) -> isSubsetOf setK setR) rSets
    ]
