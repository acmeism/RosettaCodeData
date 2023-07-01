import Data.Bifoldable (biList)
import Data.List (partition, unfoldr)
import Data.Tuple (swap)

--------------------- POPULATION COUNT -------------------
popCount :: Int -> Int
popCount = sum . unfoldr go
  where
    go x
      | 0 < x = (Just . swap) (quotRem x 2)
      | otherwise = Nothing

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    zipWith
      (\k xs -> concat [k, ":\n", show xs, "\n"])
      ["Population count of powers of 3", "evil", "odious"]
      ( (popCount . (3 ^) <$> [0 .. 29]) :
        biList (partition (even . popCount) [0 .. 59])
      )
