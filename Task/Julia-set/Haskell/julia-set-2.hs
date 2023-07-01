{-# LANGUAGE LambdaCase #-}

getJuliaValues :: Float -> Float -> Float -> Float -> Float -> Int -> [[Int]]
getJuliaValues width height centerX centerY zoom maxIter =
  [0..pred height] >>= \h -> [[0..pred width] >>= \w -> [calc h w]]
 where
  initzx x = 1.5 * (x - width  / 2) / (0.5 * zoom * width)
  initzy y = 1.0 * (y - height / 2) / (0.5 * zoom * height)
  calc y x = loop 0 (initzx x) (initzy y)
   where
    loop i zx zy
     | zx * zx + zy * zy >= 4.0 = i
     | i == maxIter = 0
     | otherwise = loop (succ i) (zx*zx - zy*zy + centerX) (2.0*zx*zy + centerY)

main :: IO ()
main = mapM_ (putStrLn . fmap (\case 0 -> '#'; _ -> ' ')) (getJuliaValues 140 50 (-0.8) 0.156 1.0 50)
