import qualified Data.Map.Strict as M

----------------- MAP OF CHARACTER COUNTS ----------------

charCounts :: String -> M.Map Char Int
charCounts =
  foldr (flip (M.insertWith (+)) 1) M.empty


--------------------------- TEST -------------------------
main :: IO ()
main =
  ( print
      . (uncurry (flip replicate) =<<)
      . M.toList
      . charCounts
  )
    "Was the misspelling of alphabetical as alphabitical a joke ?"
