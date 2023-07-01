sylvester :: [Integer]
sylvester = iterate (\x -> x * (x-1) + 1) 2
