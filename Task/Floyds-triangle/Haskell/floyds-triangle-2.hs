import Control.Monad ((>=>))
import Data.List (mapAccumL)

--------------------- FLOYD'S TRIANGLE -------------------

floyd :: Int -> [[Int]]
floyd n =
  snd $
    mapAccumL
      (\a x -> ((,) . succ <*> enumFromTo a) (a + x))
      1
      [0 .. pred n]

--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ putStrLn $ showFloyd . floyd <$> [5, 14]

showFloyd :: [[Int]] -> String
showFloyd x =
  let padRight n = (drop . length) <*> (replicate n ' ' <>)
   in unlines
        ( fmap
            ( zipWith
                (\n v -> padRight n (show v))
                (fmap (succ . length . show) (last x))
                >=> id
            )
            x
        )
