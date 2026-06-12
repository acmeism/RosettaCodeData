import Data.Matrix (Matrix, matrix)

mosaic :: Int -> Matrix Int
mosaic n =
  matrix n n ((`rem` 2) . succ . uncurry (+))

main :: IO ()
main = mapM_ (print . mosaic) [7, 8]
