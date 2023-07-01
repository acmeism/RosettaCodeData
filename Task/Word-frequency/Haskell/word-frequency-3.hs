import qualified Data.Text.IO as T
import qualified Data.Text as T

import Data.List (group, sort, sortBy)
import Data.Ord (comparing)

frequentWords :: T.Text -> [(Int, T.Text)]
frequentWords =
  sortBy (flip $ comparing fst) .
  fmap ((,) . length <*> head) . group . sort . T.words . T.toLower

main :: IO ()
main = T.readFile "miserables.txt" >>= (mapM_ print . take 10 . frequentWords)
