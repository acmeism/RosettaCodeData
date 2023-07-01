import Data.Bifunctor (bimap)

----------- SHOELACE FORMULA FOR POLYGONAL AREA ----------

-- The area of a polygon formed by
-- the list of (x, y) coordinates.

shoelace :: [(Double, Double)] -> Double
shoelace =
  let calcSums ((x, y), (a, b)) = bimap (x * b +) (a * y +)
   in (/ 2)
        . abs
        . uncurry (-)
        . foldr calcSums (0, 0)
        . (<*>) zip (tail . cycle)

--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    shoelace [(3, 4), (5, 11), (12, 8), (9, 5), (5, 6)]
