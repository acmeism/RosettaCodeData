primes = mapMaybe log2 $ fractran prog 2
  where
    prog = [17 % 91, 78 % 85, 19 % 51, 23 % 38, 29 % 33
           ,77 % 29, 95 % 23, 77 % 19, 1 % 17, 11 % 13
           ,13 % 11, 15 % 14, 15 % 2, 55 % 1]
    log2 = fmap (+ 1) . findIndex (== 2) . takeWhile even . iterate (`div` 2)
