import Data.List (zipWith)
import Text.Printf (printf)

type Point = (Double, Double)

main :: IO ()
main = do
  let points = [(1, 1), (2, 4), (3, 1), (4, 5)]
  display $ lagrangeInterpolation points

lagrangeInterpolation :: [Point] -> [Double]
lagrangeInterpolation points = sum
  where
    polys = [createPoly i | i <- [0..length points - 1]]

    createPoly i = scalarDivide poly value
      where
        poly = foldl (\acc j -> if i /= j
                               then multiply acc [-(fst (points !! j)), 1.0]
                               else acc)
                     [1.0]
                     [0..length points - 1]
        value = evaluate poly (fst (points !! i))

    sum = foldl add [0.0] weightedPolys
    weightedPolys = [scalarMultiply (polys !! i) (snd (points !! i)) | i <- [0..length points - 1]]

-- A list is used to represent a Polynomial
-- with its coefficients reversed compared to the standard mathematical notation.
-- For example, the polynomial 3x^2 + 2x + 1 is represented by the list [1, 2, 3].
add :: [Double] -> [Double] -> [Double]
add xs ys = zipWithPadded (+) 0 0 xs ys

multiply :: [Double] -> [Double] -> [Double]
multiply xs ys = foldl accumulate initial indices
  where
    lenXs = length xs
    lenYs = length ys
    initial = replicate (lenXs + lenYs - 1) 0
    indices = [(i, j) | i <- [0..lenXs-1], j <- [0..lenYs-1]]
    accumulate acc (i, j) =
      let idx = i + j
          val = (xs !! i) * (ys !! j)
      in take idx acc ++ [acc !! idx + val] ++ drop (idx + 1) acc

scalarMultiply :: [Double] -> Double -> [Double]
scalarMultiply xs scalar = map (* scalar) xs

scalarDivide :: [Double] -> Double -> [Double]
scalarDivide xs divisor = scalarMultiply xs (1.0 / divisor)

evaluate :: [Double] -> Double -> Double
evaluate poly x = foldl (\acc coef -> acc * x + coef) 0 (reverse poly)

display :: [Double] -> IO ()
display poly = putStrLn $ formatPolynomial poly

formatPolynomial :: [Double] -> String
formatPolynomial [coef] = printf "%.5f" coef
formatPolynomial poly =
  let degree = length poly - 1
      terms = [formatTerm i (poly !! i) degree | i <- [degree,degree-1..0], poly !! i /= 0]
  in if null terms then "0" else concat terms

formatTerm :: Int -> Double -> Int -> String
formatTerm power coef maxPower =
  let absCoef = abs coef
      sign = if coef < 0 then " - " else if power == maxPower then "" else " + "
      coefficient = if absCoef == 1 && power > 0 then "" else printf "%.5f" absCoef
      variable = case power of
                   0 -> if absCoef == 1 then "1" else ""
                   1 -> "x"
                   _ -> "x^" ++ show power
  in sign ++ coefficient ++ variable

-- Helper function to zip lists of different lengths with padding
zipWithPadded :: (a -> a -> a) -> a -> a -> [a] -> [a] -> [a]
zipWithPadded f padX padY [] ys = map (f padX) ys
zipWithPadded f padX padY xs [] = map (`f` padY) xs
zipWithPadded f padX padY (x:xs) (y:ys) = f x y : zipWithPadded f padX padY xs ys
