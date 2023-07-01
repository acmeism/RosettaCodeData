import Data.List (sortBy)
import qualified Data.Map.Strict as M
import Data.Ord (comparing)

charCounts :: String -> M.Map Char Int
charCounts = foldr (M.alter f) M.empty
  where
    f (Just x) = Just (succ x)
    f _ = Just 1

main :: IO ()
main =
  readFile "miserables.txt"
    >>= mapM_ print
      . sortBy
        (flip $ comparing snd)
      . M.toList
      . charCounts
