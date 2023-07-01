rk4 :: Double -> Double -> Double -> Double
rk4 y x dx =
  let f x y = x * sqrt y
      k1 = dx * f x y
      k2 = dx * f (x + dx / 2.0) (y + k1 / 2.0)
      k3 = dx * f (x + dx / 2.0) (y + k2 / 2.0)
      k4 = dx * f (x + dx) (y + k3)
  in y + (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0

actual :: Double -> Double
actual x = (1 / 16) * (x * x + 4) * (x * x + 4)

step :: Double
step = 0.1

ixs :: [Int]
ixs = [0 .. 100]

xys :: [(Double, Double)]
xys =
  scanl
    (\(x, y) _ -> (((x * 10) + (step * 10)) / 10, rk4 y x step))
    (0.0, 1.0)
    ixs

samples :: [(Double, Double, Double)]
samples =
  zip ixs xys >>=
  (\(i, (x, y)) ->
      [ (x, y, actual x - y)
      | 0 == mod i 10 ])

main :: IO ()
main =
  (putStrLn . unlines) $
  (\(x, y, v) ->
      unwords
        [ "y" ++ justifyRight 3 ' ' ('(' : show (round x)) ++ ") = "
        , justifyLeft 19 ' ' (show y)
        , '±' : show v
        ]) <$>
  samples
  where
    justifyLeft n c s = take n (s ++ replicate n c)
    justifyRight n c s = drop (length s) (replicate n c ++ s)
