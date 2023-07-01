rule n l x r = n `div` (2^(4*l + 2*x + r)) `mod` 2

initial n lst = fromList $ center $ padRight n lst
  where
    padRight n lst = take n $ lst ++ repeat 0
    center = take n . drop (n `div` 2+1) . cycle

displayCA n rule init = mapM_ putStrLn $ take n result
  where result = fmap display . view <$> runCA rule init
        display 0 = ' '
        display 1 = '*'
