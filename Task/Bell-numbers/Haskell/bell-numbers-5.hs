import Data.Ratio ((%), numerator)

infixl 7 *.
(*.) :: Num a => a -> [a] -> [a]
x *. (p:ps) = x*p : x*.ps

instance Num a => Num [a] where
    negate = map negate
    (+) = zipWith (+)
    (*) (p:ps) (q:qs) = p*q : ((p*.qs) + ps*(q:qs))
    fromInteger n = fromInteger n:repeat 0

instance (Eq a, Fractional a) => Fractional [a] where
    (/) (0:ps) (0:qs) = ps/qs
    (/) (p:ps) (q:qs) = let r=p/q in r : (ps - r*.qs)/(q:qs)

    fromRational q = fromRational q:repeat 0
