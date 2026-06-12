import qualified Data.Map.Strict as M

--------- UNIQUE CHARACTERS FROM A LIST OF STRINGS -------

uniqueChars :: [String] -> String
uniqueChars =
  M.keys . M.filter (1 ==)
    . foldr (M.unionWith (+) . charCounts) M.empty

charCounts :: String -> M.Map Char Int
charCounts =
  foldr
    (flip (M.insertWith (+)) 1)
    M.empty

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    uniqueChars
      [ "133252abcdeeffd",
        "a6789798st",
        "yxcdfgxcyz"
      ]
