cube :: Floating a => a -> a
cube x = x ** 3.0

croot :: Floating a => a -> a
croot x = x ** (1/3)

-- compose already exists in Haskell as the `.` operator
-- compose :: (a -> b) -> (b -> c) -> a -> c
-- compose f g = \x -> g (f x)

funclist :: Floating a => [a -> a]
funclist = [sin,  cos,  cube ]

invlist :: Floating a => [a -> a]
invlist  = [asin, acos, croot]

main :: IO ()
main = print $ zipWith (\f i -> f . i $ 0.5) funclist invlist
