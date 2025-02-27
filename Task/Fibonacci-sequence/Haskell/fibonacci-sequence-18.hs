fibs :: [Integer]
fibs = map numerator
    (1/(1 : (-1) : (-1) : repeat 0))
