import Data.List (elemIndex)
import Data.Char (chr, ord)
import Data.Maybe (fromJust)

mats :: [[Int]]
mats =
  [ [5, 6, 3, 1]
  , [1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2]
  , [1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]
  ]

cost :: [Int] -> Int -> Int -> (Int, Int)
cost a i j
  | i < j =
    let m =
          [ fst (cost a i k) + fst (cost a (k + 1) j) +
           (a !! i) * (a !! (j + 1)) * (a !! (k + 1))
          | k <- [i .. j - 1] ]
        mm = minimum m
    in (mm, fromJust (elemIndex mm m) + i)
  | otherwise = (0, -1)

optimalOrder :: [Int] -> Int -> Int -> String
optimalOrder a i j
  | i < j =
    let c = cost a i j
    in "(" ++ optimalOrder a i (snd c) ++ optimalOrder a (snd c + 1) j ++ ")"
  | otherwise = [chr ((+ i) $ ord 'a')]

printBlock :: [Int] -> IO ()
printBlock v =
  let c = cost v 0 (length v - 2)
  in putStrLn
       ("for " ++
        show v ++
        " we have " ++
        show (fst c) ++
        " possibilities, z.B " ++ optimalOrder v 0 (length v - 2))

main :: IO ()
main = mapM_ printBlock mats
