-- WalshMatrix.hs

-- Generate a naturally ordered Walsh matrix of size 2^k x 2^k
walsh :: Int -> [[Int]]
walsh 0 = [[1]]
walsh k =
    let smaller = walsh (k - 1)
    in combine smaller

-- Combine smaller matrix recursively to form next size
combine :: [[Int]] -> [[Int]]
combine m =
    let top    = map (\row -> row ++ row) m
        bottom = map (\row -> row ++ map negate row) m
    in top ++ bottom

-- Pads each number to a fixed width for clean columns (3 spaces here)
formatCell :: Int -> String
formatCell n =
    let s = show n
        width = 3
    in replicate (width - length s) ' ' ++ s

-- Print matrix with perfect rectangular formatting
printRectMatrix :: [[Int]] -> IO ()
printRectMatrix = mapM_ (putStrLn . unwords . map formatCell)

-- Main function: show a few sample matrices
main :: IO ()
main = do
    mapM_ printWalshMatrix [0..3]

-- Helper to print a matrix for a given k with a label
printWalshMatrix :: Int -> IO ()
printWalshMatrix k = do
    let size = 2 ^ k
    let matrix = walsh k
    putStrLn $ "\nWalsh matrix of order 2^" ++ show k ++ " (" ++ show size ++ "x" ++ show size ++ "):"
    printRectMatrix matrix
