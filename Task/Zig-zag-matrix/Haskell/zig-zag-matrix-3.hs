import Data.Text (justifyRight, pack, unpack)
import Data.List (mapAccumL)
import Data.Bool (bool)

zigZag :: Int -> [[Int]]
zigZag = go <*> diagonals
  where
    go _ [] = []
    go n xss = (head <$> edge) : go n (dropWhile null (tail <$> edge) <> rst)
      where
        (edge, rst) = splitAt n xss

diagonals :: Int -> [[Int]]
diagonals n =
  snd $ mapAccumL go [0 .. (n * n) - 1] (slope <> [n] <> reverse slope)
  where
    slope = [1 .. n - 1]
    go xs h = (rst, bool id reverse (0 /= mod h 2) grp)
      where
        (grp, rst) = splitAt h xs

main :: IO ()
main =
  putStrLn $
  unlines $
  concatMap unpack . fmap (justifyRight 3 ' ' . pack . show) <$> zigZag 5
