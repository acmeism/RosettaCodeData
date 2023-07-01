isPerfect :: Int -> Bool
isPerfect n =
  let lows = filter ((0 ==) . rem n) [1 .. floor (sqrt (fromIntegral n))]
  in 1 < n &&
     n ==
     quot
       (sum
          (lows ++
           [ y
           | x <- lows
           , let y = quot n x
           , x /= y ]))
       2

main :: IO ()
main = print $ filter isPerfect [1 .. 10000]
