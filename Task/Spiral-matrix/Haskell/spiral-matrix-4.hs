import Data.List (intercalate, transpose)
import Control.Monad (join)

spiral :: Int -> [[Int]]
spiral n = go n n 0
  where
    go rows cols start =
      if 0 < rows
        then [start .. start + pred cols] :
             fmap reverse (transpose $ go cols (pred rows) (start + cols))
        else [[]]

main :: IO ()
main = putStrLn $ wikiTable (spiral 5)


-- TABLE FORMATTING ----------------------------------------

wikiTable :: Show a => [[a]] -> String
wikiTable =
  join .
  ("{| class=\"wikitable\" style=\"text-align:center;" :) .
  ("width:12em;height:12em;table-layout:fixed;\"\n|-\n" :) .
  return .
  (++ "\n|}") .
  intercalate "\n|-\n" .
  fmap (('|' :) . (' ' :) . intercalate " || " . fmap show)
