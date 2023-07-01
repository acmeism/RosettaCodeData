displayCA n rule init = mapM_ putStrLn $ take n result
  where result = fmap display . elems <$> runCA rule init
        display 0 = ' '
        display 1 = '*'
