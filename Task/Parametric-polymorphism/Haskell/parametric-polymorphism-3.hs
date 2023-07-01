add1Everywhere :: (Functor f, Num a) => f a -> f a
add1Everywhere nums = fmap (\x -> x + 1) nums
