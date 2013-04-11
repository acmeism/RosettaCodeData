import Data.List

xs <+> ys = zipWith (+) xs ys
xs <*> ys = sum $ zipWith (*) xs ys

newtype Mat a = Mat {unMat :: [[a]]} deriving Eq

instance Show a => Show (Mat a) where
  show xm = "Mat " ++ show (unMat xm)

instance Num a => Num (Mat a) where
  negate xm = Mat $ map (map negate) $ unMat xm
  xm + ym   = Mat $ zipWith (<+>) (unMat xm) (unMat ym)
  xm * ym   = Mat [[xs <*> ys | ys <- transpose $ unMat ym] | xs <- unMat xm]
  fromInteger n = Mat [[fromInteger n]]
