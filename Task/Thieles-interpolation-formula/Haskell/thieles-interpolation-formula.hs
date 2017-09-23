thiele :: [Double] -> [Double] -> Double -> Double
thiele xs ys = f rho1 (tail xs)
  where
    f _ [] _ = 1
    f r@(r0:r1:r2:rs) (x:xs) v = r2 - r0 + (v - x) / f (tail r) xs v
    rho1 = ((!! 1) . (++ [0])) <$> rho
    rho = [0,0 ..] : [0,0 ..] : ys : rnext (tail rho) xs (tail xs)
      where
        rnext _ _ [] = []
        rnext r@(r0:r1:rs) x xn =
          let z_ = zipWith
          in z_ (+) (tail r0) (z_ (/) (z_ (-) x xn) (z_ (-) r1 (tail r1))) :
             rnext (tail r) x (tail xn)

-- Inverted interpolation function of f
invInterp :: (Double -> Double) -> [Double] -> Double -> Double
invInterp f xs = thiele (map f xs) xs

main :: IO ()
main =
  mapM_
    print
    [ 3.21 * inv_sin (sin (pi / 3.21))
    , pi / 1.2345 * inv_cos (cos 1.2345)
    , 7 * inv_tan (tan (pi / 7))
    ]
  where
    [inv_sin, inv_cos, inv_tan] =
      uncurry ((. div_pi) . invInterp) <$>
      [(sin, (2, 31)), (cos, (2, 100)), (tan, (4, 1000))]
    -- N points taken uniformly from 0 to Pi/d
    div_pi (d, n) = (* (pi / (d * n))) <$> [0 .. n]
