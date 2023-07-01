inCarpet :: Int -> Int -> Bool
inCarpet 0 _ = True
inCarpet _ 0 = True
inCarpet x y = not ((xr == 1) && (yr == 1)) && inCarpet xq yq
  where ((xq, xr), (yq, yr)) = (x `divMod` 3, y `divMod` 3)

carpet :: Int -> [String]
carpet n = map
            (zipWith
              (\x y -> if inCarpet x y then '#' else ' ')
              [0..3^n-1]
             . repeat)
            [0..3^n-1]

printCarpet :: Int -> IO ()
printCarpet = mapM_ putStrLn . carpet
