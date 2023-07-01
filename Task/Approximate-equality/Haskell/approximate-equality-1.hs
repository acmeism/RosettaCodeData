class (Num a, Ord a, Eq a) => AlmostEq a where
  eps :: a

infix 4 ~=
(~=) :: AlmostEq a => a -> a -> Bool
a ~= b = or [ a == b
            , abs (a - b) < eps * abs(a + b)
            , abs (a - b) < eps ]

instance AlmostEq Int where eps = 0
instance AlmostEq Integer where eps = 0
instance AlmostEq Double where eps = 1e-14
instance AlmostEq Float where eps = 1e-5
