{-# LANGUAGE ParallelListComp #-}
import Numeric.LinearAlgebra (linearSolve, toDense, (!), flatten)
import Data.Monoid ((<>), Sum(..))

rMesh n (ar, ac) (br, bc)
  | n < 2 = Nothing
  | any (\x -> x < 1 || x > n) [ar, ac, br, bc] = Nothing
  | otherwise = between a b <$> voltage
  where
    a = (ac - 1) + n*(ar - 1)
    b = (bc - 1) + n*(br - 1)

    between x y v = abs (v ! a - v ! b)

    voltage = flatten <$> linearSolve matrixG current

    matrixG = toDense $ concat [ element row col node
                               | row <- [1..n], col <- [1..n]
                               | node <- [0..] ]

    element row col node =
      let (Sum c, elements) =
            (Sum 1, [((node, node-n), -1)]) `when` (row > 1) <>
            (Sum 1, [((node, node+n), -1)]) `when` (row < n) <>
            (Sum 1, [((node, node-1), -1)]) `when` (col > 1) <>
            (Sum 1, [((node, node+1), -1)]) `when` (col < n)
      in [((node, node), c)] <> elements

    x `when` p = if p then x else mempty

    current  = toDense [ ((a, 0), -1) , ((b, 0),  1) , ((n^2-1, 0), 0) ]
