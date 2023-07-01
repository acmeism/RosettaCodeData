import Control.Monad (join)
import Data.Bifunctor (bimap)
import Text.Printf (printf)

type Radians = Float

type Degrees = Float

---------- ANGLE DIFFERENCE BETWEEN TWO BEARINGS ---------

bearingDelta :: (Radians, Radians) -> Radians
bearingDelta (a, b) -- sign * dot-product
  =
  sign * acos ((ax * bx) + (ay * by))
  where
    (ax, ay) = (sin a, cos a)
    (bx, by) = (sin b, cos b)
    sign
      | ((ay * bx) - (by * ax)) > 0 = 1
      | otherwise = -1

angleBetweenDegrees :: (Degrees, Degrees) -> Degrees
angleBetweenDegrees =
  degrees
    . bearingDelta
    . join bimap radians

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn . unlines $
    fmap
      ( uncurry (printf "%6.2f° - %6.2f°  ->  %7.2f°")
          <*> angleBetweenDegrees
      )
      [ (20.0, 45.0),
        (-45.0, 45.0),
        (-85.0, 90.0),
        (-95.0, 90.0),
        (-45.0, 125.0),
        (-45.0, 145.0)
      ]

------------------------- GENERIC ------------------------

degrees :: Radians -> Degrees
degrees = (/ pi) . (180 *)

radians :: Degrees -> Radians
radians = (/ 180) . (pi *)
