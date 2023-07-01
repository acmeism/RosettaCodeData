rule n l x r = n `div` (2^(4*l + 2*x + r)) `mod` 2

initial n = listArray (0,n-1) . center . padRight n
  where
    padRight n lst = take n $ lst ++ repeat 0
    center = take n . drop (n `div` 2+1) . cycle
