import Data.List (sortOn)
import Data.Ord (Down (Down))

---------- MINIMUM NUMBER OF COINS TO MAKE A SUM ---------

change :: [Int] -> Int -> Either String [(Int, Int)]
change units n
  | 0 == mod n m = Right $ go (sortOn Down units) (abs n)
  | otherwise =
    Left $
      concat
        [ "Residue of ",
          show (mod n m),
          " - no denomination smaller than ",
          show m,
          "."
        ]
  where
    m = minimum units
    go _ 0 = []
    go [] _ = []
    go (x : xs) n
      | 0 == q = go xs n
      | otherwise = (q, x) : go xs r
      where
        (q, r) = quotRem n x

--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ putStrLn $ test <$> [1024, 988]
  where
    test n =
      either
        id
        ( concat
            . (:) ("Summing to " <> show n <> ":\n")
            . fmap
              ( \(q, v) ->
                  concat
                    [show q, " * ", show v, "\n"]
              )
        )
        (change [200, 100, 50, 20, 10, 5, 2, 1] n)
