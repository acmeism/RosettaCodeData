triangles :: Int -> [[Int]]
triangles max_peri
  | max_peri < 12 = []
  | otherwise = concat tiers
  where
    tiers = takeWhile (not . null) $ iterate tier [[3, 4, 5]]
    tier = concatMap (filter ((<= max_peri) . sum) . tmul)
    tmul t =
      map
        (map (sum . zipWith (*) t))
        [ [[1, -2, 2], [2, -1, 2], [2, -2, 3]],
          [[1, 2, 2], [2, 1, 2], [2, 2, 3]],
          [[-1, 2, 2], [-2, 1, 2], [-2, 2, 3]]
        ]

triangleCount max_p = (length t, sum $ map ((max_p `div`) . sum) t)
  where
    t = triangles max_p

main :: IO ()
main =
  mapM_
    ((putStrLn . (\n -> show n <> " " <> show (triangleCount n))) . (10 ^))
    [1 .. 7]
