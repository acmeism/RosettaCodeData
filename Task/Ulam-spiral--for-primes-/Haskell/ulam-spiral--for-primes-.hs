import Data.List
import Data.Numbers.Primes

-- Add a row to existing spiral by rotating right and adding new row to top
-- Results in spirals that turn in the wrong direction and must later be fixed.
addRow :: [[Int]] -> [[Int]]
addRow spiral = let height = length spiral
                    width = length $ head spiral
                    row = [height*width+1.. height*width+height]
                in row : reverse (transpose spiral)

-- Generate spiral by adding two rows (vertical & horizontal) to smaller spiral
preSpiral :: Int => [[Int]]
preSpiral 1 = [[1]]
preSpiral n = addRow $ addRow $ preSpiral (n-1)

-- Make ulamSpiral; fix spiral direction by flipping preSpiral.
ulamSpiral :: Int => [[Int]]
ulamSpiral n | odd n = reverse $ preSpiral n
             | otherwise =  map reverse $ preSpiral n

-- Make and print ulamSpiral:
    -- Use converter to change numbers to strings.
    -- Change empty strings to dashes.
    -- Pad strings out to correct length before printing.
prettyPrintSpiral :: Int -> (Int -> String) -> IO ()
prettyPrintSpiral n converter =
        let stringSpiral = map (map converter) (ulamSpiral n)
            maxLen = maximum (map (maximum.map length) stringSpiral)
            dashFunc s = if s == "" then replicate maxLen '-' else s
            padFunc s = replicate (maxLen - length s)  ' ' ++ s
            padded = map (padFunc.dashFunc)
            showRow = unwords.padded
        in mapM_ (putStrLn.showRow) stringSpiral


main :: IO ()
main = do
          -- Display with converter that shows primes as Strings.
          prettyPrintSpiral 10 (\n -> if isPrime n then show n else "")

          putStrLn ""

          -- Display with converter that shows primes as single dots.
          prettyPrintSpiral 60 (\n -> if isPrime n then "*" else " ")
