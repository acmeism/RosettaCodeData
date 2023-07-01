add (a, b) (x, y) = (a + x, b + y)
sub (a, b) (x, y) = (a - x, b - y)
magSqr (a, b)     = (a ^^ 2) + (b ^^ 2)
mag a             = sqrt $ magSqr a
mul (a, b) c      = (a * c, b * c)
div2 (a, b) c     = (a / c, b / c)
perp (a, b)       = (negate b, a)
norm a            = a `div2` mag a

circlePoints :: (Ord a, Floating a) =>
                (a, a) -> (a, a) -> a -> Maybe ((a, a), (a, a))
circlePoints p q radius
  | radius == 0      = Nothing
  | p == q           = Nothing
  | diameter < magPQ = Nothing
  | otherwise        = Just (center1, center2)
  where
    diameter = radius * 2
    pq       = p `sub` q
    magPQ    = mag pq
    midpoint = (p `add` q) `div2` 2
    halfPQ   = magPQ / 2
    magMidC  = sqrt . abs $ (radius ^^ 2) - (halfPQ ^^ 2)
    midC     = (norm $ perp pq) `mul` magMidC
    center1  = midpoint `add` midC
    center2  = midpoint `sub` midC

uncurry3 f (a, b, c) = f a b c

main :: IO ()
main = mapM_ (print . uncurry3 circlePoints)
  [((0.1234, 0.9876), (0.8765, 0.2345), 2),
   ((0     , 2     ), (0     , 0     ), 1),
   ((0.1234, 0.9876), (0.1234, 0.9876), 2),
   ((0.1234, 0.9876), (0.8765, 0.2345), 0.5),
   ((0.1234, 0.9876), (0.1234, 0.1234), 0)]
