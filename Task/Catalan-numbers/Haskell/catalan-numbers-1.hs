infixl 7 *.
(*.) :: Num a => a -> [a] -> [a]
x *. (p:ps) = x*p : x*.ps

instance Num a => Num [a] where
    negate = map negate
    (+) = zipWith (+)
    (*) (p:ps) (q:qs) = p*q : ((p*.qs) + ps*(q:qs))
    fromInteger n = fromInteger n:repeat 0
