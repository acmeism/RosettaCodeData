import Control.Applicative

data Root a = Exact a | Approximate a deriving (Show, Eq)

-- looks for roots on an interval
bisection :: (Alternative f, Floating a, Ord a) =>
             (a -> a) -> a -> a -> f (Root a)
bisection f a b | f a * f b > 0 = empty
                | f a == 0      = pure (Exact a)
                | f b == 0      = pure (Exact b)
                | smallInterval = pure (Approximate c)
                | otherwise     = bisection f a c <|> bisection f c b
  where c = (a + b) / 2
        smallInterval = abs (a-b) < 1e-15 || abs ((a-b)/c) < 1e-15

-- looks for roots on a grid
findRoots :: (Alternative f, Floating a, Ord a) =>
             (a -> a) -> [a] -> а (Root a)
findRoots f []       = empty
findRoots f [x]      = if f x == 0 then pure (Exact x) else empty
findRoots f (a:b:xs) = bisection f a b <|> findRoots f (b:xs)
