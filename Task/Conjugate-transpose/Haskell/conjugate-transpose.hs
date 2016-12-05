import Data.List (transpose)
import Data.Complex

type Matrix a = [[a]]

main :: IO ()
main =
    mapM_ (\a -> do
        putStrLn "\nMatrix:"
        mapM_ print a
        putStrLn "Conjugate Transpose:"
        mapM_ print (conjTranspose a)
        putStrLn $ "Hermitian? " ++ show (isHermitianMatrix a)
        putStrLn $ "Normal? " ++ show (isNormalMatrix a)
        putStrLn $ "Unitary? " ++ show (isUnitaryMatrix a))
        ([[[3,       2:+1],
           [2:+(-1), 1   ]],

          [[1, 1, 0],
           [0, 1, 1],
           [1, 0, 1]],

          [[sqrt 2/2:+0, sqrt 2/2:+0,     0   ],
           [0:+sqrt 2/2, 0:+ (-sqrt 2/2), 0   ],
           [0,           0,               0:+1]]] :: [Matrix (Complex Double)])

isHermitianMatrix, isNormalMatrix, isUnitaryMatrix :: RealFloat a => Matrix (Complex a) -> Bool
isHermitianMatrix a = a `approxEqualMatrix` conjTranspose a
isNormalMatrix a = (a `mmul` conjTranspose a) `approxEqualMatrix` (conjTranspose a `mmul` a)
isUnitaryMatrix a = (a `mmul` conjTranspose a) `approxEqualMatrix` ident (length a)

approxEqualMatrix :: (Fractional a, Ord a) => Matrix (Complex a) -> Matrix (Complex a) -> Bool
approxEqualMatrix a b = length a == length b && length (head a) == length (head b) &&
                        and (zipWith approxEqualComplex (concat a) (concat b))
    where approxEqualComplex (rx :+ ix) (ry :+ iy) = abs (rx - ry) < eps && abs (ix - iy) < eps
          eps = 1e-14

mmul :: Num a => Matrix a -> Matrix a -> Matrix a
mmul a b = [[sum (zipWith (*) row column) | column <- transpose b] | row <- a]

ident :: Num a => Int -> Matrix a
ident size = [[fromIntegral $ div a b * div b a | a <- [1..size]] | b <- [1..size]]

conjTranspose :: Num a => Matrix (Complex a) -> Matrix (Complex a)
conjTranspose = map (map conjugate) . transpose
