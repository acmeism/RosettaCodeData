import Data.Ratio ((%))

real2cf :: (RealFrac a, Integral b) => a -> [b]
real2cf x =
  let (i, f) = properFraction x
  in i :
     if f == 0
       then []
       else real2cf (1 / f)

main :: IO ()
main =
  mapM_
    print
    [ real2cf (13 % 11)
    , take 20 $ real2cf (sqrt 2)
    ]
