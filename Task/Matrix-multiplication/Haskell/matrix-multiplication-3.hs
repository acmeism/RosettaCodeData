multiply :: Num a => [[a]] -> [[a]] -> [[a]]
multiply us vs = map (mult [] vs) us
  where
    mult xs [] _ = xs
    mult xs _ [] = xs
    mult [] (zs:zss) (y:ys) = mult (map (y *) zs) zss ys
    mult xs (zs:zss) (y:ys) = mult (zipWith (\u v -> u + v * y) xs zs) zss ys

main :: IO ()
main = mapM_ print $ multiply [[1, 2], [3, 4]] [[-3, -8, 3], [-2, 1, 4]
