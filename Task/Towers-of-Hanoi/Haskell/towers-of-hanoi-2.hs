hanoi :: Integer -> a -> a -> a -> [(a, a)]

hanoi n a b c = hanoiToList n a b c []
  where
    hanoiToList 0 _ _ _ l = l
    hanoiToList n a b c l = hanoiToList (n-1) a c b ((a, b) : hanoiToList (n-1) c b a l)
