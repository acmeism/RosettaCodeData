module Main where

import Data.List (intercalate, transpose)
import Text.Printf (printf, PrintfArg)

-- Matrix data type
data Matrix a = Matrix { matrixData :: [[a]]
                       , rows :: Int
                       , cols :: Int
                       } deriving (Eq)

-- Constructor
new :: [[a]] -> Matrix a
new [] = Matrix [] 0 0
new dat = Matrix dat (length dat) (length $ head dat)

-- Getters
getRows :: Matrix a -> Int
getRows = rows

getCols :: Matrix a -> Int
getCols = cols

-- Validation functions
validateDimensions :: Matrix a -> Matrix a -> Either String ()
validateDimensions m1 m2
    | getRows m1 == getRows m2 && getCols m1 == getCols m2 = Right ()
    | otherwise = Left "Matrices must have the same dimensions."

validateMultiplication :: Matrix a -> Matrix a -> Either String ()
validateMultiplication m1 m2
    | getCols m1 == getRows m2 = Right ()
    | otherwise = Left "Cannot multiply these matrices."

validateSquarePowerOfTwo :: Matrix a -> Either String ()
validateSquarePowerOfTwo m
    | r /= c = Left "Matrix must be square."
    | r == 0 || not (isPowerOfTwo r) = Left "Size of matrix must be a power of two."
    | otherwise = Right ()
  where
    r = getRows m
    c = getCols m
    isPowerOfTwo n = n > 0 && n == 2^(floor (logBase 2 (fromIntegral n)))

-- Matrix operations
matrixAdd :: Num a => Matrix a -> Matrix a -> Either String (Matrix a)
matrixAdd m1 m2 = do
    validateDimensions m1 m2
    let result = zipWith (zipWith (+)) (matrixData m1) (matrixData m2)
    return $ new result

matrixSubtract :: Num a => Matrix a -> Matrix a -> Either String (Matrix a)
matrixSubtract m1 m2 = do
    validateDimensions m1 m2
    let result = zipWith (zipWith (-)) (matrixData m1) (matrixData m2)
    return $ new result

matrixMultiply :: Num a => Matrix a -> Matrix a -> Either String (Matrix a)
matrixMultiply m1 m2 = do
    validateMultiplication m1 m2
    let data1 = matrixData m1
        data2 = matrixData m2
        cols2 = transpose data2
        result = [[sum $ zipWith (*) row col | col <- cols2] | row <- data1]
    return $ new result

-- String representation
matrixToString :: Show a => Matrix a -> String
matrixToString m = unlines $ map formatRow (matrixData m)
  where
    formatRow row = "[" ++ intercalate ", " (map show row) ++ "]"

matrixToStringWithPrecision :: (RealFloat a, PrintfArg a) => Matrix a -> Int -> String
matrixToStringWithPrecision m p = unlines $ map (formatRowWithPrecision p) (matrixData m)
  where
    formatRowWithPrecision precision row =
        "[" ++ intercalate ", " (map (formatElementWithPrecision precision) row) ++ "]"

    formatElementWithPrecision precision e =
        let pow = 10.0 ^ precision
            rounded = fromIntegral (round (e * pow)) / pow
            formatted = printf ("%." ++ show precision ++ "f") rounded
            zeroCheck = if precision == 0 then "0" else "0." ++ replicate precision '0'
        in if formatted == ("-" ++ zeroCheck) then zeroCheck else formatted

-- Strassen multiplication helper functions
toQuarters :: Matrix a -> [Matrix a]
toQuarters m = [new q0Data, new q1Data, new q2Data, new q3Data]
  where
    r = getRows m `div` 2
    dat = matrixData m
    (topHalf, bottomHalf) = splitAt r dat

    q0Data = map (take r) topHalf
    q1Data = map (drop r) topHalf
    q2Data = map (take r) bottomHalf
    q3Data = map (drop r) bottomHalf

fromQuarters :: [Matrix a] -> Matrix a
fromQuarters [q0, q1, q2, q3] = new (topHalf ++ bottomHalf)
  where
    q0Data = matrixData q0
    q1Data = matrixData q1
    q2Data = matrixData q2
    q3Data = matrixData q3

    topHalf = zipWith (++) q0Data q1Data
    bottomHalf = zipWith (++) q2Data q3Data
fromQuarters _ = error "fromQuarters expects exactly 4 matrices"

-- Safe matrix operations for Strassen (using Either for error handling)
safeAdd :: Num a => Matrix a -> Matrix a -> Matrix a
safeAdd m1 m2 = case matrixAdd m1 m2 of
    Right result -> result
    Left err -> error err

safeSubtract :: Num a => Matrix a -> Matrix a -> Matrix a
safeSubtract m1 m2 = case matrixSubtract m1 m2 of
    Right result -> result
    Left err -> error err

safeMultiply :: Num a => Matrix a -> Matrix a -> Matrix a
safeMultiply m1 m2 = case matrixMultiply m1 m2 of
    Right result -> result
    Left err -> error err

-- Strassen multiplication
strassen :: Num a => Matrix a -> Matrix a -> Either String (Matrix a)
strassen m1 m2 = do
    validateSquarePowerOfTwo m1
    validateSquarePowerOfTwo m2
    if getRows m1 /= getRows m2 || getCols m1 /= getCols m2
        then Left "Matrices must be square and of equal size for Strassen multiplication."
        else Right $ strassenImpl m1 m2

strassenImpl :: Num a => Matrix a -> Matrix a -> Matrix a
strassenImpl m1 m2
    | getRows m1 == 1 = safeMultiply m1 m2
    | otherwise = fromQuarters [c11, c12, c21, c22]
  where
    [a11, a12, a21, a22] = toQuarters m1
    [b11, b12, b21, b22] = toQuarters m2

    -- Calculate the 7 products according to Strassen's algorithm
    p1 = strassenImpl a11 (safeSubtract b12 b22)
    p2 = strassenImpl (safeAdd a11 a12) b22
    p3 = strassenImpl (safeAdd a21 a22) b11
    p4 = strassenImpl a22 (safeSubtract b21 b11)
    p5 = strassenImpl (safeAdd a11 a22) (safeAdd b11 b22)
    p6 = strassenImpl (safeSubtract a12 a22) (safeAdd b21 b22)
    p7 = strassenImpl (safeSubtract a11 a21) (safeAdd b11 b12)

    -- Calculate result quarters
    c11 = safeAdd (safeSubtract (safeAdd p5 p4) p2) p6
    c12 = safeAdd p1 p2
    c21 = safeAdd p3 p4
    c22 = safeSubtract (safeSubtract (safeAdd p5 p1) p3) p7

-- Main function for testing
main :: IO ()
main = do
    let aData = [[1.0, 2.0], [3.0, 4.0]] :: [[Double]]
        a = new aData

        bData = [[5.0, 6.0], [7.0, 8.0]] :: [[Double]]
        b = new bData

        cData = [[1.0, 1.0, 1.0, 1.0], [2.0, 4.0, 8.0, 16.0],
                 [3.0, 9.0, 27.0, 81.0], [4.0, 16.0, 64.0, 256.0]] :: [[Double]]
        c = new cData

        dData = [[4.0, -3.0, 4.0/3.0, -1.0/4.0],
                 [-13.0/3.0, 19.0/4.0, -7.0/3.0, 11.0/24.0],
                 [3.0/2.0, -2.0, 7.0/6.0, -1.0/4.0],
                 [-1.0/6.0, 1.0/4.0, -1.0/6.0, 1.0/24.0]] :: [[Double]]
        d = new dData

        eData = [[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0],
                 [9.0, 10.0, 11.0, 12.0], [13.0, 14.0, 15.0, 16.0]] :: [[Double]]
        e = new eData

        fData = [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0],
                 [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]] :: [[Double]]
        f = new fData

    putStrLn "Using 'normal' matrix multiplication:"
    case matrixMultiply a b of
        Right result -> putStrLn $ "  a * b = \n" ++ matrixToString result
        Left err -> putStrLn $ "Error: " ++ err

    case matrixMultiply c d of
        Right result -> putStrLn $ "  c * d = \n" ++ matrixToStringWithPrecision result 6
        Left err -> putStrLn $ "Error: " ++ err

    case matrixMultiply e f of
        Right result -> putStrLn $ "  e * f = \n" ++ matrixToString result
        Left err -> putStrLn $ "Error: " ++ err

    putStrLn "\nUsing 'Strassen' matrix multiplication:"
    case strassen a b of
        Right result -> putStrLn $ "  a * b = \n" ++ matrixToString result
        Left err -> putStrLn $ "Error: " ++ err

    case strassen c d of
        Right result -> putStrLn $ "  c * d = \n" ++ matrixToStringWithPrecision result 6
        Left err -> putStrLn $ "Error: " ++ err

    case strassen e f of
        Right result -> putStrLn $ "  e * f = \n" ++ matrixToString result
        Left err -> putStrLn $ "Error: " ++ err
