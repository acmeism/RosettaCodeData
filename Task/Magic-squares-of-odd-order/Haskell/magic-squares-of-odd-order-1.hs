-- as a translation from imperative code, this is probably not a "good" implementation
import Data.List

type Var = (Int, Int, Int, Int) -- sx sy sz c

magicSum :: Int -> Int
magicSum x = ((x * x + 1) `div` 2) * x

wrapInc :: Int -> Int -> Int
wrapInc max x
   | x + 1 == max    = 0
   | otherwise       = x + 1

wrapDec :: Int -> Int -> Int
wrapDec max x
   | x == 0    = max - 1
   | otherwise = x - 1

isZero :: [[Int]] -> Int -> Int -> Bool
isZero m x y = m !! x !! y == 0

setAt :: (Int,Int) -> Int -> [[Int]] -> [[Int]]
setAt (x, y) val table
   | (upper, current : lower) <- splitAt x table,
     (left, this : right) <- splitAt y current
         = upper ++ (left ++ val : right) : lower
   | otherwise = error "Outside"

create :: Int -> [[Int]]
create x = replicate x $ replicate x 0

cells :: [[Int]] -> Int
cells m = x*x where x = length m

fill :: Var -> [[Int]] -> [[Int]]
fill (sx, sy, sz, c) m
   | c < cells m =
      if isZero m sx sy
      then fill ((wrapInc sz sx), (wrapDec sz sy), sz, c + 1) (setAt (sx, sy) (c + 1) m)
      else fill ((wrapDec sz sx), (wrapInc sz(wrapInc sz sy)), sz, c) m
   | otherwise = m

magicNumber :: Int -> [[Int]]
magicNumber d = transpose $ fill (d `div` 2, 0, d, 0) (create d)

display :: [[Int]] -> String
display (x:xs)
   | null xs = vdisplay x
   | otherwise = vdisplay x ++ ('\n' : display xs)

vdisplay :: [Int] -> String
vdisplay (x:xs)
   | null xs = show x
   | otherwise = show x ++ " " ++ vdisplay xs


magicSquare x = do
   putStr "Magic Square of "
   putStr $ show x
   putStr " = "
   putStrLn $ show $ magicSum x
   putStrLn $ display $ magicNumber x
