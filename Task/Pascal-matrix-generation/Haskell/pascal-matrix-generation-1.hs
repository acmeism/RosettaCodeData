import Data.List (transpose)
import System.Environment (getArgs)
import Text.Printf (printf)

-- Pascal's triangle.
pascal :: [[Int]]
pascal = iterate (\row -> 1 : zipWith (+) row (tail row) ++ [1]) [1]

-- The n by n Pascal lower triangular matrix.
pascLow :: Int -> [[Int]]
pascLow n = zipWith (\row i -> row ++ replicate (n-i) 0) (take n pascal) [1..]

-- The n by n Pascal upper triangular matrix.
pascUp :: Int -> [[Int]]
pascUp = transpose . pascLow

-- The n by n Pascal symmetric matrix.
pascSym :: Int -> [[Int]]
pascSym n = take n . map (take n) . transpose $ pascal

-- Format and print a matrix.
printMat :: String -> [[Int]] -> IO ()
printMat title mat = do
  putStrLn $ title ++ "\n"
  mapM_ (putStrLn . concatMap (printf " %2d")) mat
  putStrLn "\n"

main :: IO ()
main = do
  ns <- fmap (map read) getArgs
  case ns of
    [n] -> do printMat "Lower triangular" $ pascLow n
              printMat "Upper triangular" $ pascUp  n
              printMat "Symmetric"        $ pascSym n
    _   -> error "Usage: pascmat <number>"
