import Data.Tuple.Curry

main :: IO ()
main =
  mapM_ putStrLn $
  concatMap
    (("" :) . uncurryN task)
    [ ((-10, 11), (10, -9), ((3, -5), 3))
    , ((-10, 11), (-11, 12), ((3, -5), 3))
    , ((3, -2), (7, -2), ((3, -5), 3))
    , ((3, -2), (7, -2), ((0, 0), 4))
    , ((0, -3), (0, 6), ((0, 0), 4))
    , ((6, 3), (10, 7), ((4, 2), 5))
    , ((7, 4), (11, 18), ((4, 2), 5))
    ]

task :: (Double, Double)
     -> (Double, Double)
     -> ((Double, Double), Double)
     -> [String]
task pt1 pt2 circle@(pt3@(a3, b3), r) = [line, segment]
  where
    xs = map fun $ lineCircleIntersection pt1 pt2 circle
    ys = map fun $ segmentCircleIntersection pt1 pt2 circle
    to x = (fromIntegral . round $ 100 * x) / 100
    fun (x, y) = (to x, to y)
    yo = show . fun
    start = "Intersection: Circle " ++ yo pt3 ++ " " ++ show (to r) ++ " and "
    end = yo pt1 ++ " " ++ yo pt2 ++ ": "
    line = start ++ "Line " ++ end ++ show xs
    segment = start ++ "Segment " ++ end ++ show ys

segmentCircleIntersection
  :: (Double, Double)
  -> (Double, Double)
  -> ((Double, Double), Double)
  -> [(Double, Double)]
segmentCircleIntersection pt1 pt2 circle =
  filter (go p1 p2) $ lineCircleIntersection pt1 pt2 circle
  where
    [p1, p2]
      | pt1 < pt2 = [pt1, pt2]
      | otherwise = [pt2, pt1]
    go (x, y) (u, v) (i, j)
      | x == u = y <= j && j <= v
      | otherwise = x <= i && i <= u

lineCircleIntersection
  :: (Double, Double)
  -> (Double, Double)
  -> ((Double, Double), Double)
  -> [(Double, Double)]
lineCircleIntersection (a1, b1) (a2, b2) ((a3, b3), r) = go delta
  where
    (x1, x2) = (a1 - a3, a2 - a3)
    (y1, y2) = (b1 - b3, b2 - b3)
    (dx, dy) = (x2 - x1, y2 - y1)
    drdr = dx * dx + dy * dy
    d = x1 * y2 - x2 * y1
    delta = r * r * drdr - d * d
    sqrtDelta = sqrt delta
    (sgnDy, absDy) = (sgn dy, abs dy)
    u1 = (d * dy + sgnDy * dx * sqrtDelta) / drdr
    u2 = (d * dy - sgnDy * dx * sqrtDelta) / drdr
    v1 = (-d * dx + absDy * sqrtDelta) / drdr
    v2 = (-d * dx - absDy * sqrtDelta) / drdr
    go x
      | 0 > x = []
      | 0 == x = [(u1 + a3, v1 + b3)]
      | otherwise = [(u1 + a3, v1 + b3), (u2 + a3, v2 + b3)]

sgn :: Double -> Double
sgn x
  | 0 > x = -1
  | otherwise = 1
