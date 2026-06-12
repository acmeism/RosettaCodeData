import Data.Bifunctor (bimap)
import Data.Matrix (Matrix, matrix)

----------- SHORTEST DISTANCES TO EDGE OF MATRIX ---------

distancesToEdge :: Int -> Matrix Int
distancesToEdge n = matrix n n (uncurry min . bimap f f)
  where
    m = quot n 2
    f i
      | i <= m = pred i
      | otherwise = n - i

--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ print $ distancesToEdge <$> [10, 9, 2, 1]
