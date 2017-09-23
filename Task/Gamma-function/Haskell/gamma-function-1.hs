cof :: [Double]
cof =
  [ 76.18009172947146
  , -86.50532032941677
  , 24.01409824083091
  , -1.231739572450155
  , 0.001208650973866179
  , -0.000005395239384953
  ]

ser :: Double
ser = 1.000000000190015

gammaln :: Double -> Double
gammaln xx =
  let tmp_ = (xx + 5.5) - (xx + 0.5) * log (xx + 5.5)
      ser_ = ser + sum (zipWith (/) cof [xx + 1 ..])
  in -tmp_ + log (2.5066282746310005 * ser_ / xx)

main :: IO ()
main = mapM_ print $ gammaln <$> [0.1,0.2 .. 1.0]
