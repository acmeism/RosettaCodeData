import Data.List (mapAccumL)
import Data.Text (justifyRight, pack, unpack)

zigZag :: Int -> [[Int]]
zigZag n = horizontals n (diagonals n)
  where

    diagonals :: Int -> [[Int]]
    diagonals n =
      snd $
      mapAccumL
        (\xs h ->
            let (grp, rst) = splitAt h xs
            in ( rst
               , (if mod h 2 /= 0
                    then reverse
                    else id)
                   grp))
        [0 .. (n * n) - 1]
        (slope ++ [n] ++ reverse slope)
      where
        slope = [1 .. n - 1]

    horizontals :: Int -> [[Int]] -> [[Int]]
    horizontals n xss =
      if not (null xss)
        then let (edge, rst) = splitAt n xss
             in (head <$> edge) :
                horizontals n (dropWhile null (tail <$> edge) ++ rst)
        else []

main :: IO ()
main =
  putStrLn $
  unlines $
  (concat . (unpack <$>)) . ((justifyRight 3 ' ' . pack . show) <$>) <$>
  zigZag 5
