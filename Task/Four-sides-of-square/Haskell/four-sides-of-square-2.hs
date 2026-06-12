import Data.Matrix

------------------ FOUR SIDES OF A SQUARE ----------------

fourSides :: Int -> Matrix Int
fourSides n = matrix n n
  (\(i, j) -> (fromEnum . or) ((==) <$> [1, n] <*> [i, j]))


--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ print $ fourSides <$> [0 .. 5]
