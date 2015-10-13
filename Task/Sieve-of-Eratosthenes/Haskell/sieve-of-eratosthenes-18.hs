fix ( (2:) . concat
      . unfoldr (\(a:b:t) -> Just . second ((:t) . (`minus` b))
                                  . span (< head b) $ a)
      . ([3..] :) . map (\p-> [p*p, p*p+p..]) )
