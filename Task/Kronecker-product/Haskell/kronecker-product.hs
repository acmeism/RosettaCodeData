import Data.List (transpose)

-------------------- KRONECKER PRODUCT -------------------

kroneckerProduct :: Num a => [[a]] -> [[a]] -> [[a]]
kroneckerProduct xs ys =
  fmap (`f` ys) <$> xs
    >>= fmap concat . transpose
  where
    f = fmap . fmap . (*)


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    print
    ( kroneckerProduct
        [[1, 2], [3, 4]]
        [[0, 5], [6, 7]]
    )
    >> putStrLn []
    >> mapM_
      print
      ( kroneckerProduct
          [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
          [[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]]
      )
