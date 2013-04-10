import Data.List

h, f, g :: [Double]
h = [-8,-9,-3,-1,-6,7]
f = [-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1]
g = [24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7]

scale x ys = map (x*) ys

deconv1d :: (Fractional a) => [a] -> [a] -> [a]
deconv1d xs ys = takeWhile (/=0) $ deconv xs ys
  where [] `deconv` _ = []
        (0:xs) `deconv` (0:ys) = xs `deconv` ys
        (x:xs) `deconv` (y:ys) =
          q : zipWith (-) xs (scale q ys ++ repeat 0) `deconv` (y:ys)
            where q = x / y
