import Data.List (intercalate, transpose)

---------------------- SPIRAL MATRIX ---------------------
spiral :: Int -> [[Int]]
spiral n = go n n 0
  where
    go rows cols x
      | 0 < rows =
          [x .. pred cols + x] :
          fmap
            reverse
            (transpose $ go cols (pred rows) (x + cols))
      | otherwise = [[]]


--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ wikiTable $ spiral 5


--------------------- TABLE FORMATTING -------------------
wikiTable :: Show a => [[a]] -> String
wikiTable =
  concat
    . ("{| class=\"wikitable\" style=\"text-align: right;" :)
    . ("width:12em;height:12em;table-layout:fixed;\"\n|-\n" :)
    . return
    . (<> "\n|}")
    . intercalate "\n|-\n"
    . fmap (('|' :) . (' ' :) . intercalate " || " . fmap show)
