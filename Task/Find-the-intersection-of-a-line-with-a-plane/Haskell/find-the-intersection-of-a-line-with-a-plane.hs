import Control.Applicative (liftA2)
import Text.Printf (printf)

data V3 a = V3 a a a
    deriving Show

instance Functor V3 where
    fmap f (V3 a b c) = V3 (f a) (f b) (f c)

instance Applicative V3 where
    pure a = V3 a a a
    V3 a b c <*> V3 d e f = V3 (a d) (b e) (c f)

instance Num a => Num (V3 a) where
    (+) = liftA2 (+)
    (-) = liftA2 (-)
    (*) = liftA2 (*)
    negate = fmap negate
    abs = fmap abs
    signum = fmap signum
    fromInteger = pure . fromInteger

dot ::Num a => V3 a -> V3 a -> a
dot a b = x + y + z
  where
    V3 x y z = a * b

intersect :: Fractional a => V3 a -> V3 a -> V3 a -> V3 a -> V3 a
intersect rayVector rayPoint planeNormal planePoint =
    rayPoint - rayVector * pure prod3
  where
    diff = rayPoint - planePoint
    prod1 = diff `dot` planeNormal
    prod2 = rayVector `dot` planeNormal
    prod3 = prod1 / prod2

main = printf "The ray intersects the plane at (%f, %f, %f)\n" x y z
  where
    V3 x y z = intersect rv rp pn pp :: V3 Double
    rv = V3 0 (-1) (-1)
    rp = V3 0 0 10
    pn = V3 0 0 1
    pp = V3 0 0 5
