import Control.Monad (join)
import Data.Matrix (Matrix, getElem, matrix, nrows, toLists)

--------------------- FLOYDS TRIANGLE --------------------

floyd :: Int -> Matrix (Maybe Int)
floyd n = matrix n n go
  where
    go (y, x)
      | x > y = Nothing
      | otherwise = Just (x + quot (pred y * y) 2)


--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ putStrLn $ showFloyd . floyd <$> [5, 14]


------------------------- DISPLAY ------------------------

showFloyd :: Matrix (Maybe Int) -> String
showFloyd m =
  (unlines . fmap unwords . toLists) $
    go <$> m
  where
    go Nothing = ""
    go (Just n) = padRight w (show n)
    Just v = join getElem (nrows m) m
    w = length (show v)

padRight :: Int -> String -> String
padRight n = (drop . length) <*> (replicate n ' ' <>)
