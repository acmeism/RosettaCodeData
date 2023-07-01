import Data.Bifunctor (bimap)
import Text.Printf (printf)

------------------------ KOCH CURVE ----------------------
kochSnowflake ::
  Int ->
  (Float, Float) ->
  (Float, Float) ->
  [(Float, Float)]
kochSnowflake n a b =
  concat $
    zipWith (kochCurve n) points (xs <> [x])
  where
    points@(x : xs) = [a, equilateralApex a b, b]

kochCurve ::
  Int ->
  (Float, Float) ->
  (Float, Float) ->
  [(Float, Float)]
kochCurve n ab xy = ab : go n (ab, xy)
  where
    go 0 (_, xy) = [xy]
    go n (ab, xy) =
      let (mp, mq) = midThirdOfLine ab xy
          points@(_ : xs) =
            [ ab,
              mp,
              equilateralApex mp mq,
              mq,
              xy
            ]
       in go (pred n) =<< zip points xs

equilateralApex ::
  (Float, Float) ->
  (Float, Float) ->
  (Float, Float)
equilateralApex = rotatedPoint (pi / 3)

rotatedPoint ::
  Float ->
  (Float, Float) ->
  (Float, Float) ->
  (Float, Float)
rotatedPoint theta (ox, oy) (a, b) = (ox + dx, oy - dy)
  where
    (dx, dy) = rotatedVector theta (a - ox, oy - b)

rotatedVector :: Float -> (Float, Float) -> (Float, Float)
rotatedVector angle (x, y) =
  ( x * cos angle - y * sin angle,
    x * sin angle + y * cos angle
  )

midThirdOfLine ::
  (Float, Float) ->
  (Float, Float) ->
  ((Float, Float), (Float, Float))
midThirdOfLine (a, b) (x, y) = (p, f p)
  where
    (dx, dy) = ((x - a) / 3, (y - b) / 3)
    f = bimap (dx +) (dy +)
    p = f (a, b)

-------------------------- TEST ---------------------------
main :: IO ()
main =
  putStrLn $
    svgFromPoints 1024 $
      kochSnowflake 4 (200, 600) (800, 600)

-------------------------- SVG ----------------------------
svgFromPoints :: Int -> [(Float, Float)] -> String
svgFromPoints w xys =
  unlines
    [ "<svg xmlns=\"http://www.w3.org/2000/svg\"",
      unwords
        [ "width=\"512\" height=\"512\" viewBox=\"5 5",
          sw,
          sw,
          "\"> "
        ],
      "<path d=\"M" <> points <> "\" ",
      unwords [
        "stroke-width=\"2\"",
        "stroke=\"red\"",
        "fill=\"transparent\"/>"
      ],
      "</svg>"
    ]
  where
    sw = show w
    showN = printf "%.2g"
    points =
      ( unwords
          . fmap
            ( ((<>) . showN . fst)
                <*> ((' ' :) . showN . snd)
            )
      )
        xys
