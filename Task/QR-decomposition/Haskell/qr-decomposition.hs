import Data.List
import Text.Printf (printf)

eps = 1e-6 :: Double

-- a matrix is represented as a list of columns
mmult :: Num a => [[a]] -> [[a]] -> [[a]]
nth :: Num a => [[a]] -> Int -> Int -> a
mmult_num :: Num a => [[a]] -> a -> [[a]]
madd :: Num a => [[a]] -> [[a]] -> [[a]]
idMatrix :: Num a => Int -> Int -> [[a]]

adjustWithE :: [[Double]] -> Int -> [[Double]]

mmult a b = [ [ sum $ zipWith (*) ak bj | ak <- (transpose a) ] | bj <- b ]
nth mA i j = (mA !! j) !! i
mmult_num mA n = map (\c -> map (*n) c) mA
madd mA mB = zipWith (\c1 c2 -> zipWith (+) c1 c2) mA mB
idMatrix n m = [ [if (i==j) then 1 else 0 | i <- [1..n]] | j <- [1..m]]

adjustWithE mA n = let lA = length mA in
    (idMatrix n (n - lA)) ++ (map (\c -> (take (n - lA) (repeat 0.0)) ++ c ) mA)

-- auxiliary functions
sqsum :: Floating a => [a] -> a
norm :: Floating a => [a] -> a
epsilonize :: [[Double]] -> [[Double]]

sqsum a = foldl (\x y -> x + y*y) 0 a
norm a = sqrt $! sqsum a
epsilonize mA = map (\c -> map (\x -> if abs x <= eps then 0 else x) c) mA

-- Householder transformation; householder A = (Q, R)
uTransform :: [Double] -> [Double]
hMatrix :: [Double] -> Int -> Int -> [[Double]]
householder :: [[Double]] -> ([[Double]], [[Double]])

-- householder_rec Q R A
householder_rec :: [[Double]] -> [[Double]] -> Int -> ([[Double]], [[Double]])

uTransform a = let t = (head a) + (signum (head a))*(norm a) in
    1 : map (\x -> x/t) (tail a)

hMatrix a n i = let u = uTransform (drop i a) in
    madd
        (idMatrix (n-i) (n-i))
        (mmult_num
            (mmult [u] (transpose [u]))
            ((/) (-2) (sqsum u)))

householder_rec mQ mR 0 = (mQ, mR)
householder_rec mQ mR n = let mSize = length mR in
    let mH = adjustWithE (hMatrix (mR!!(mSize - n)) mSize (mSize - n)) mSize in
        householder_rec (mmult mQ mH) (mmult mH mR) (n - 1)

householder mA = let mSize = length mA in
    let (mQ, mR) = householder_rec (idMatrix mSize mSize) mA mSize in
        (epsilonize mQ, epsilonize mR)

backSubstitution :: [[Double]] -> [Double] -> [Double] -> [Double]
backSubstitution mR [] res = res
backSubstitution mR@(hR:tR) q@(h:t) res =
    let x = (h / (head hR)) in
        backSubstitution
            (map tail tR)
            (tail (zipWith (-) q (map (*x) hR)))
            (x : res)

showMatrix :: [[Double]] -> String
showMatrix mA =
    concat $ intersperse "\n"
        (map (\x -> unwords $ printf "%10.4f" <$> (x::[Double])) (transpose mA))

mY = [[12, 6, -4], [-51, 167, 24], [4, -68, -41]] :: [[Double]]
q = [21, 245, 35] :: [Double]
main = let (mQ, mR) = householder mY in
    putStrLn ("Q: \n" ++ showMatrix mQ) >>
    putStrLn ("R: \n" ++ showMatrix mR) >>
    putStrLn ("q: \n" ++ show q) >>
    putStrLn ("x: \n" ++ show (backSubstitution (reverse (map reverse mR)) (reverse q) []))
