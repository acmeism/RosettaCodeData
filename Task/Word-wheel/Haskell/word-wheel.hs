import Data.Char (toLower)
import Data.List (sort)
import System.IO (readFile)

------------------------ WORD WHEEL ----------------------

gridWords :: [String] -> [String] -> [String]
gridWords grid =
  filter
    ( ((&&) . (2 <) . length)
        <*> (((&&) . elem mid) <*> wheelFit wheel)
    )
  where
    cs = toLower <$> concat grid
    wheel = sort cs
    mid = cs !! 4

wheelFit :: String -> String -> Bool
wheelFit wheel = go wheel . sort
  where
    go _ [] = True
    go [] _ = False
    go (w : ws) ccs@(c : cs)
      | w == c = go ws cs
      | otherwise = go ws ccs

--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= ( mapM_ putStrLn
            . gridWords ["NDE", "OKG", "ELW"]
            . lines
        )
