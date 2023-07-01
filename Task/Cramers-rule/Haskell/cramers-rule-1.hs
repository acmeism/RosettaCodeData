import Data.Matrix

solveCramer :: (Ord a, Fractional a) => Matrix a -> Matrix a -> Maybe [a]
solveCramer a y
  | da == 0 = Nothing
  | otherwise = Just $ map (\i -> d i / da) [1..n]
  where da = detLU a
        d i = detLU $ submatrix 1 n 1 n $ switchCols i (n+1) ay
        ay = a <|> y
        n = ncols a

task = solveCramer a y
  where a = fromLists [[2,-1, 5, 1]
                      ,[3, 2, 2,-6]
                      ,[1, 3, 3,-1]
                      ,[5,-2,-3, 3]]
        y = fromLists [[-3], [-32], [-47], [49]]
