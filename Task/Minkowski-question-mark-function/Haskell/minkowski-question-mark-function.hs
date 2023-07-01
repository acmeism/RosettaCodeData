import Data.Tree
import Data.Ratio
import Data.List

intervalTree :: (a -> a -> a) -> (a, a) -> Tree a
intervalTree node = unfoldTree $
  \(a, b) -> let m = node a b in (m, [(a,m), (m,b)])

Node a _ ==> Node b [] = const b
Node a [] ==> Node b _ = const b
Node a [l1, r1] ==> Node b [l2, r2] =
  \x -> case x `compare` a of
          LT -> (l1 ==> l2) x
          EQ -> b
          GT -> (r1 ==> r2) x

mirror :: Num a => Tree a -> Tree a
mirror t = Node 0 [reflect (negate <$> t), t]
  where
    reflect (Node a [l,r]) = Node a [reflect r, reflect l]

------------------------------------------------------------

sternBrocot :: Tree Rational
sternBrocot = toRatio <$> intervalTree mediant ((0,1), (1,0))
  where
    mediant (p, q) (r, s) = (p + r, q + s)

toRatio (p, q) = p % q

minkowski :: Tree Rational
minkowski = toRatio <$> intervalTree mean ((0,1), (1,0))

mean (p, q) (1, 0) = (p+1, q)
mean (p, q) (r, s) = (p*s + q*r, 2*q*s)


questionMark, invQuestionMark :: Rational -> Rational
questionMark    = mirror sternBrocot ==> mirror minkowski
invQuestionMark = mirror minkowski ==> mirror sternBrocot

------------------------------------------------------------
-- Floating point trees and functions

sternBrocotF :: Tree Double
sternBrocotF = mirror $ fromRational <$> sternBrocot

minkowskiF :: Tree Double
minkowskiF = mirror $ intervalTree mean (0, 1/0)
  where
    mean a b | isInfinite b = a + 1
             | otherwise = (a + b) / 2

questionMarkF, invQuestionMarkF :: Double -> Double
questionMarkF = sternBrocotF ==> minkowskiF
invQuestionMarkF = minkowskiF ==> sternBrocotF
