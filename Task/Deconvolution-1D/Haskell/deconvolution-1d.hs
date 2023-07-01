deconv1d :: [Double] -> [Double] -> [Double]
deconv1d xs ys = takeWhile (/= 0) $ deconv xs ys
  where
    [] `deconv` _ = []
    (0:xs) `deconv` (0:ys) = xs `deconv` ys
    (x:xs) `deconv` (y:ys) =
      let q = x / y
      in q : zipWith (-) xs (scale q ys ++ repeat 0) `deconv` (y : ys)

scale :: Double -> [Double] -> [Double]
scale = map . (*)

h, f, g :: [Double]
h = [-8, -9, -3, -1, -6, 7]

f = [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1]

g =
  [ 24
  , 75
  , 71
  , -34
  , 3
  , 22
  , -45
  , 23
  , 245
  , 25
  , 52
  , 25
  , -67
  , -96
  , 96
  , 31
  , 55
  , 36
  , 29
  , -43
  , -7
  ]

main :: IO ()
main = print $ (h == deconv1d g f) && (f == deconv1d g h)
