import Data.Ratio ((%), numerator)

infixl 7 *.
(*.) :: Num a => a -> [a] -> [a]
x *. (p:ps) = x*p : x*.ps

instance Num a => Num [a] where
    negate = map negate
    (+) = zipWith (+)
    (*) (p:ps) (q:qs) = p*q : ((p*.qs) + ps*(q:qs))
    fromInteger n = fromInteger n:repeat 0

expseq :: [Rational] -> [Rational]
expseq ps = zipWith (\p q -> p*fromInteger q) ps (scanl (*) 1 [1..])
