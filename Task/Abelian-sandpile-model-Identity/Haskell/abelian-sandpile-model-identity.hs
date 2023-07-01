{-# LANGUAGE TupleSections #-}

import Data.List (findIndex, transpose)
import Data.List.Split (chunksOf)

--------------------------- TEST ---------------------------
main :: IO ()
main = do
  let s0 = [[4, 3, 3], [3, 1, 2], [0, 2, 3]]
      s1 = [[1, 2, 0], [2, 1, 1], [0, 1, 3]]
      s2 = [[2, 1, 3], [1, 0, 1], [0, 1, 0]]
      s3_id = [[2, 1, 2], [1, 0, 1], [2, 1, 2]]
      s3 = replicate 3 (replicate 3 3)
      x:xs = reverse $ cascade s0
  mapM_
    putStrLn
    [ "Cascade:"
    , showCascade $ ([], x) : fmap ("->", ) xs

    , "s1 + s2 == s2 + s1 -> " <> show (addSand s1 s2 == addSand s2 s1)
    , showCascade [([], s1), (" +", s2), (" =", addSand s1 s2)]
    , showCascade [([], s2), (" +", s1), (" =", addSand s2 s1)]

    , "s3 + s3_id == s3 -> " <> show (addSand s3 s3_id == s3)
    , showCascade [([], s3), (" +", s3_id), (" =", addSand s3 s3_id)]

    , "s3_id + s3_id == s3_id -> " <> show (addSand s3_id s3_id == s3_id)
    , showCascade [([], s3_id), (" +", s3_id), (" =", addSand s3_id s3_id)]
    ]

------------------------ SAND PILES ------------------------
addSand :: [[Int]] -> [[Int]] -> [[Int]]
addSand xs ys =
  (head . cascade . chunksOf (length xs)) $ zipWith (+) (concat xs) (concat ys)

cascade :: [[Int]] -> [[[Int]]]
cascade xs = chunksOf w <$> convergence (==) (iterate (tumble w) (concat xs))
  where
    w = length xs

convergence :: (a -> a -> Bool) -> [a] -> [a]
convergence p = go
  where
    go (x:ys@(y:_))
      | p x y = [x]
      | otherwise = go ys <> [x]

tumble :: Int -> [Int] -> [Int]
tumble w xs = maybe xs go $ findIndex (w <) xs
  where
    go i = zipWith f [0 ..] xs
      where
        neighbours = indexNeighbours w i
        f j x
          | j `elem` neighbours = succ x
          | i == j = x - succ w
          | otherwise = x

indexNeighbours :: Int -> Int -> [Int]
indexNeighbours w = go
  where
    go i =
      concat
        [ [ j
          | j <- [i - w, i + w]
          , -1 < j
          , wSqr > j ]
        , [ pred i
          | 0 /= col ]
        , [ succ i
          | pred w /= col ]
        ]
      where
        wSqr = w * w
        col = rem i w

------------------------- DISPLAY --------------------------
showCascade :: [(String, [[Int]])] -> String
showCascade pairs =
  unlines $
  fmap unwords $
  transpose $
  fmap
    (\(pfx, xs) ->
        unwords <$> transpose (centered pfx : transpose (fmap (fmap show) xs)))
    pairs

centered :: String -> [String]
centered s = [pad, s, pad <> replicate r ' ']
  where
    lng = length s
    pad = replicate lng ' '
    (q, r) = quotRem (2 + lng) 2
