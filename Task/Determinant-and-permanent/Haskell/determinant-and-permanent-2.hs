outer :: (a->b->c) -> [a] -> [b] -> [[c]]
outer f [] _       = []
outer f _ []       = []
outer f (h1:t1) x2 = (f h1 <$> x2) : outer f t1 x2

dot [] []           = 0
dot (h1:t1) (h2:t2) = (h1*h2) + (dot t1 t2)

transpose [] = []
transpose ([] : xss) = transpose xss
transpose ((x:xs) : xss)
  = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

mul :: Num a => [[a]] -> [[a]] -> [[a]]
mul a b = outer dot a (transpose b)

delRow :: Int -> [a] -> [a]
delRow i v =
  (first ++ rest) where (first, _:rest) = splitAt i v

delCol :: Int -> [[a]] -> [[a]]
delCol j m = (delRow j) <$> m

-- Determinant:
adj :: Num a => [[a]] -> [[a]]
adj [] = []
adj m =
  [
    [(-1)^(i+j) * det (delRow i $ delCol j m)
    | i <- [0.. -1+length m]
    ]
  | j <- [0.. -1+length m]
  ]
det :: Num a => [[a]] -> a
det [] = 1
det m  = (mul m (adj m)) !! 0 !! 0

-- Permanent:
padj :: Num a => [[a]] -> [[a]]
padj [] = []
padj m =
  [
    [perm (delRow i $ delCol j m)
    | i <- [0.. -1+length m]
    ]
  | j <- [0.. -1+length m]
  ]
perm :: Num a => [[a]] -> a
perm [] = 1
perm m  = (mul m (padj m)) !! 0 !! 0
