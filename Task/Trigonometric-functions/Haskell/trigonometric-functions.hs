fromDegrees :: Floating a => a -> a
fromDegrees deg = deg * pi / 180

toDegrees :: Floating a => a -> a
toDegrees rad = rad * 180 / pi

main :: IO ()
main =
  mapM_
    print
    [ sin (pi / 6)
    , sin (fromDegrees 30)
    , cos (pi / 6)
    , cos (fromDegrees 30)
    , tan (pi / 6)
    , tan (fromDegrees 30)
    , asin 0.5
    , toDegrees (asin 0.5)
    , acos 0.5
    , toDegrees (acos 0.5)
    , atan 0.5
    , toDegrees (atan 0.5)
    ]
