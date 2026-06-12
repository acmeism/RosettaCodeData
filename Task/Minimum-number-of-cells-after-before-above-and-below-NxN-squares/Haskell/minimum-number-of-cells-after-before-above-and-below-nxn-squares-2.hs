import Data.Matrix ( matrix, Matrix )

----------- SHORTEST DISTANCES TO EDGE OF MATRIX ---------

distancesToEdge :: Int -> Matrix Int
distancesToEdge n = matrix n n
  (\(i, j) -> minimum $ ($) <$> [pred, (n -)] <*> [i, j])


--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ print $ distancesToEdge <$> [10, 9, 2, 1]
