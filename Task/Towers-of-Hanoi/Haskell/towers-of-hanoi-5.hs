import Data.Monoid ((<>), mempty)
import Data.List (intercalate, transpose)

hanoi :: Int -> t -> t -> t -> [[t]]
hanoi 0 _ _ _ = mempty
hanoi n l r m = hanoi (n - 1) l m r <> [[l, r]] <> hanoi (n - 1) m r l

showHanoi :: Int -> String
showHanoi n =
  unlines $
  intercalate " ->   " <$>
  transpose
    ((justifyLeft 6 ' ' <$>) <$> transpose (hanoi n "left" "right" "mid"))

justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s <> replicate n c)

-- TEST -------------------------------------------------------------
main :: IO ()
main = putStrLn $ showHanoi 5
