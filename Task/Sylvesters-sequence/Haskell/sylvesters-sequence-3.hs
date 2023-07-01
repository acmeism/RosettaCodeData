sylvester :: [Integer]
sylvester = iterate (succ . ((*) <*> pred)) 2
