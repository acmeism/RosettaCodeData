class  Eq a  where
   (==) :: a -> a -> Bool
   (/=) :: a -> a -> Bool
   x /= y     =  not (x == y)
   x == y     =  not (x /= y)
