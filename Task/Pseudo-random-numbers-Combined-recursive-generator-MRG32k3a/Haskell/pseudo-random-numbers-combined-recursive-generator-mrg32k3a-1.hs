import Data.List

randoms :: Int -> [Int]
randoms seed = unfoldr go ([seed,0,0],[seed,0,0])
  where
    go (x1,x2) =
      let x1i = sum (zipWith (*) x1 a1) `mod` m1
          x2i = sum (zipWith (*) x2 a2) `mod` m2
      in Just $ ((x1i - x2i) `mod` m1, (x1i:init x1, x2i:init x2))

    a1 = [0, 1403580, -810728]
    m1 = 2^32 - 209
    a2 = [527612, 0, -1370589]
    m2 = 2^32 - 22853

randomsFloat = map ((/ (2^32 - 208)) . fromIntegral) . randoms
