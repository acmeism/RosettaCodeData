import Data.Monoid ((<>), mempty)
import Data.List (intercalate, transpose)

hanoi :: Int -> t -> t -> t -> [[t]]
hanoi n l r m =
  if n > 0
    then hanoi (n - 1) l m r <> [[l, r]] <> hanoi (n - 1) m r l
    else mempty

-- TEST (hanoi 5) -------------------------------------------------------------
main :: IO ()
main =
  mapM_ putStrLn $
  intercalate " ->   " <$>
  transpose
    ((justifyLeft 6 ' ' <$>) <$> transpose (hanoi 5 "left" "right" "mid"))
  where
    justifyLeft n c s = take n (s <> replicate n c)
