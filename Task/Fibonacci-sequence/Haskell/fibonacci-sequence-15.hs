import Data.List (transpose)

fib
  :: (Integral b, Num a)
  => b -> a
fib 0 = 0 -- this line is necessary because "something ^ 0" returns "fromInteger 1", which unfortunately
-- in our case is not our multiplicative identity (the identity matrix) but just a 1x1 matrix of 1
fib n = (last . head . unMat) (Mat [[1, 1], [1, 0]] ^ n)

-- Code adapted from Matrix exponentiation operator task ---------------------
(<+>)
  :: Num c
  => [c] -> [c] -> [c]
(<+>) = zipWith (+)

(<*>)
  :: Num a
  => [a] -> [a] -> a
(<*>) = (sum .) . zipWith (*)

newtype Mat a = Mat
  { unMat :: [[a]]
  } deriving (Eq)

instance Show a =>
         Show (Mat a) where
  show xm = "Mat " ++ show (unMat xm)

instance Num a =>
         Num (Mat a) where
  negate xm = Mat $ map (map negate) $ unMat xm
  xm + ym = Mat $ zipWith (<+>) (unMat xm) (unMat ym)
  xm * ym =
    Mat
      [ [ xs Main.<*> ys -- to distinguish from standard applicative operator
        | ys <- transpose $ unMat ym ]
      | xs <- unMat xm ]
  fromInteger n = Mat [[fromInteger n]]
  abs = undefined
  signum = undefined

-- TEST ----------------------------------------------------------------------
main :: IO ()
main = (print . take 10 . show . fib) (10 ^ 5)
