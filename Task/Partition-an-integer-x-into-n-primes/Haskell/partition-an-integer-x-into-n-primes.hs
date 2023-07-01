import Data.List (delete, intercalate)
import Data.Numbers.Primes (primes)
import Data.Bool (bool)

-------------------- PRIME PARTITIONS ---------------------
partitions :: Int -> Int -> [Int]
partitions x n
  | n <= 1 =
    [ x
    | x == last ps ]
  | otherwise = go ps x n
  where
    ps = takeWhile (<= x) primes
    go ps_ x 1 =
      [ x
      | x `elem` ps_ ]
    go ps_ x n = ((flip bool [] . head) <*> null) (ps_ >>= found)
      where
        found p =
          ((flip bool [] . return . (p :)) <*> null)
            ((go =<< delete p . flip takeWhile ps_ . (>=)) (x - p) (pred n))

-------------------------- TEST ---------------------------
main :: IO ()
main =
  mapM_ putStrLn $
  (\(x, n) ->
      intercalate
        " -> "
        [ justifyLeft 9 ' ' (show (x, n))
        , let xs = partitions x n
          in bool
               (tail $ concatMap (('+' :) . show) xs)
               "(no solution)"
               (null xs)
        ]) <$>
  concat
    [ [(99809, 1), (18, 2), (19, 3), (20, 4), (2017, 24)]
    , (,) 22699 <$> [1 .. 4]
    , [(40355, 3)]
    ]

------------------------- GENERIC -------------------------
justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s ++ replicate n c)
