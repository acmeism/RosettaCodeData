import Data.List (transpose)

(<+>)
  :: Num a
  => [a] -> [a] -> [a]
(<+>) = zipWith (+)

(<*>)
  :: Num a
  => [a] -> [a] -> a
(<*>) = (sum .) . zipWith (*)

newtype Mat a =
  Mat [[a]]
  deriving (Eq, Show)

instance Num a =>
         Num (Mat a) where
  negate (Mat x) = Mat $ map (map negate) x
  Mat x + Mat y = Mat $ zipWith (<+>) x y
  Mat x * Mat y =
    Mat
      [ [ xs Main.<*> ys -- Main prefix to distinguish fron applicative operator
        | ys <- transpose y ]
      | xs <- x ]
  abs = undefined
  fromInteger _ = undefined -- don't know dimension of the desired matrix
  signum = undefined

-- TEST ----------------------------------------------------------------------
main :: IO ()
main = print $ Mat [[1, 2], [0, 1]] ^ 4
