import Data.List (groupBy)

nnPeers :: Int -> [Int] -> Bool
nnPeers n = const (any p . groupBy bothN) n
  where
    p g@(h:_) = n == h && n == length g
    bothN x y = n == x && x == y


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    unlines $
      fmap
        (\xs -> show xs <> " -> " <> show (nnPeers 3 xs))
        [ [9, 3, 3, 3, 2, 1, 7, 8, 5],
          [5, 2, 9, 3, 3, 7, 8, 4, 1],
          [1, 4, 3, 6, 7, 3, 8, 3, 2],
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
          [4, 6, 8, 7, 2, 3, 3, 3, 1]
        ]
