import Data.Matrix

twoDiagonals :: Int -> Matrix Int
twoDiagonals n =
  matrix
    n
    n
    (\(a, b) -> fromEnum $ a `elem` [b, succ (n - b)])

main :: IO ()
main =
  mapM_ print $ twoDiagonals <$> [7, 8]
