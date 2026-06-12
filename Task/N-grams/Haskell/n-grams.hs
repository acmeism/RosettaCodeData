import Control.Applicative (ZipList (ZipList, getZipList))
import Data.Char (toUpper)
import Data.List (tails)
import qualified Data.Map.Strict as M

------------------- MAP OF N-GRAM COUNTS -----------------

nGramCounts :: Int -> String -> M.Map String Int
nGramCounts n =
  foldr (flip (M.insertWith (+)) 1) M.empty . windows n


------------------------- GENERIC ------------------------

windows :: Int -> [a] -> [[a]]
windows n = transpose . take n . tails

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose xs = getZipList (traverse ZipList xs)


--------------------------- TEST -------------------------
main :: IO ()
main =
  let sample = toUpper <$> "Live and let live"
   in mapM_
        ( \n ->
            putStrLn (show n <> "-GRAMS:")
              >> mapM_ print ((M.assocs . nGramCounts n) sample)
              >> putStrLn ""
        )
        [0 .. 4]
