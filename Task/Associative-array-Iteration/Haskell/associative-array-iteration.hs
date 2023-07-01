import qualified Data.Map as M

myMap :: M.Map String Int
myMap = M.fromList [("hello", 13), ("world", 31), ("!", 71)]

main :: IO ()
main =
  (putStrLn . unlines) $
  [ show . M.toList     -- Pairs
  , show . M.keys       -- Keys
  , show . M.elems      -- Values
  ] <*>
  pure myMap
