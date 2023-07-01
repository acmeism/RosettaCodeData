rule n l x r = n `div` (2^(4*l + 2*x + r)) `mod` 2

displayCA n w rule init = mapM_ putStrLn $ take n result
  where result = fmap display . view w <$> runCA rule init
        display 0 = ' '
        display _ = '*'
