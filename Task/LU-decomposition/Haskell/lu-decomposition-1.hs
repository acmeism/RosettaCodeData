import Data.List
import Data.Maybe
import Text.Printf

-- a matrix is represented as a list of columns
mmult :: Num a => [[a]] -> [[a]] -> [[a]]
mmult a b = [ [ sum $ zipWith (*) ak bj | ak <- (transpose a) ] | bj <- b ]

nth mA i j = (mA !! j) !! i

idMatrixPart n m k = [ [if (i==j) then 1 else 0 | i <- [1..n]] | j <- [k..m]]
idMatrix n = idMatrixPart n n 1

permMatrix n ix1 ix2 =
    [ [ if ((i==ix1 && j==ix2) || (i==ix2 && j==ix1) || (i==j && j /= ix1 && i /= ix2))
        then 1 else 0| i <- [0..n-1]] | j <- [0..n-1]]
permMatrix_inv n ix1 ix2 = permMatrix n ix2 ix1

-- count k from zero
elimColumn :: Int -> [[Rational]] -> Int -> [Rational]
elimMatrix :: Int -> [[Rational]] -> Int -> [[Rational]]
elimMatrix_inv :: Int -> [[Rational]] -> Int -> [[Rational]]

elimColumn n mA k = [(let mAkk = (nth mA k k) in  if (i>k) then (-(nth mA i k)/mAkk)
    else if (i==k) then 1 else 0) | i <- [0..n-1]]
elimMatrix n mA k = (idMatrixPart n k 1) ++ [elimColumn n mA k] ++ (idMatrixPart n n (k+2))
elimMatrix_inv n mA k = (idMatrixPart n k 1) ++ --mA is elimMatrix there
    [let c = (mA!!k) in [if (i==k) then 1 else if (i<k) then 0 else (-(c!!i)) | i <- [0..n-1]]]
     ++ (idMatrixPart n n (k+2))

swapIndx :: [[Rational]] -> Int -> Int
swapIndx mA k = fromMaybe k (findIndex (>0) (drop k (mA!!k)))

-- LUP; lupStep returns [L:U:P]
paStep_recP :: Int -> [[Rational]] -> [[Rational]] -> [[Rational]] -> Int -> [[[Rational]]]
paStep_recM :: Int -> [[Rational]] -> [[Rational]] -> [[Rational]] -> Int -> [[[Rational]]]
lupStep :: Int -> [[Rational]] -> [[[Rational]]]

paStep_recP n mP mA mL cnt =
    let mPt = permMatrix n cnt (swapIndx mA cnt) in
        let mPtInv = permMatrix_inv n cnt (swapIndx mA cnt) in
    if (cnt >= n) then [(mmult mP mL),mA,mP] else
        (paStep_recM n (mmult mPt mP) (mmult mPt mA) (mmult mL mPtInv) cnt)

paStep_recM n mP mA mL cnt =
    let mMt = elimMatrix n mA cnt in
        let mMtInv = elimMatrix_inv n mMt cnt in
    paStep_recP n mP (mmult mMt mA) (mmult mL mMtInv) (cnt + 1)

lupStep n mA = paStep_recP n (idMatrix n) mA (idMatrix n) 0

--IO
matrixFromRationalToString m = concat $ intersperse "\n"
    (map (\x -> unwords $ printf "%8.4f" <$> (x::[Double]))
        (transpose (matrixFromRational m))) where
        matrixFromRational m = map (\x -> map fromRational x) m

solveTask mY = let mLUP = lupStep (length mY) mY in
    putStrLn ("A: \n" ++ matrixFromRationalToString mY) >>
    putStrLn ("L: \n" ++ matrixFromRationalToString (mLUP!!0)) >>
    putStrLn ("U: \n" ++ matrixFromRationalToString (mLUP!!1)) >>
    putStrLn ("P: \n" ++ matrixFromRationalToString (mLUP!!2)) >>
    putStrLn ("Verify: PA\n" ++ matrixFromRationalToString (mmult (mLUP!!2) mY)) >>
    putStrLn ("Verify: LU\n" ++ matrixFromRationalToString (mmult (mLUP!!0) (mLUP!!1)))

mY1 = [[1, 2, 1], [3, 4, 7], [5, 7, 0]] :: [[Rational]]
mY2 = [[11, 1, 3, 2], [9, 5, 17, 5], [24, 2, 18, 7], [2, 6, 1, 1]] :: [[Rational]]
main = putStrLn "Task1: \n" >> solveTask mY1 >>
    putStrLn "Task2: \n" >> solveTask mY2
