import Control.Applicative

cof :: [Double]
cof =
  [ 76.18009172947146
  , -86.50532032941677
  , 24.01409824083091
  , -1.231739572450155
  , 0.001208650973866179
  , -0.000005395239384953
  ]

gammaln :: Double -> Double
gammaln =
  ((+) . negate . (((-) . (5.5 +)) <*> (((*) . (0.5 +)) <*> (log . (5.5 +))))) <*>
  (log .
   ((/) =<<
    (2.5066282746310007 *) .
    (1.000000000190015 +) . sum . zipWith (/) cof . enumFrom . (1 +)))

main :: IO ()
main = mapM_ print $ gammaln <$> [0.1,0.2 .. 1.0]
