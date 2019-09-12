import Data.Text (justifyRight, pack, unpack)
import Data.List (mapAccumL)
import Data.Bool (bool)

zigZag :: Int -> [[Int]]
zigZag = horizontals <*> diagonals
  where
    diagonals n =
      let slope = [1 .. n - 1]
      in snd $
         mapAccumL
           (\xs h ->
               let (grp, rst) = splitAt h xs
               in (rst, bool id reverse (0 /= mod h 2) grp))
           [0 .. (n * n) - 1]
           (slope ++ [n] ++ reverse slope)
    horizontals n xss
      | null xss = []
      | otherwise =
        let (edge, rst) = splitAt n xss
        in (head <$> edge) :
           horizontals n (dropWhile null (tail <$> edge) ++ rst)

main :: IO ()
main =
  putStrLn $
  unlines $
  concatMap unpack . fmap (justifyRight 3 ' ' . pack . show) <$> zigZag 5
