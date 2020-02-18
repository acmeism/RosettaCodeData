import Data.List (findIndices)

tf :: [[Int] -> Bool] -> [[Int]]
tf = traverse (const [1, 0])

wrongness :: [Int] -> [[Int] -> Bool] -> [Int]
wrongness ns ps = findIndices id (zipWith (/=) ns (map (fromEnum . ($ ns)) ps))

statements :: [[Int] -> Bool]
statements =
  [ (== 12) . length
  , 3 ⊂ [length statements - 6 ..]
  , 2 ⊂ [1,3 ..]
  , 4 → [4 .. 6]
  , 0 ⊂ [1 .. 3]
  , 4 ⊂ [0,2 ..]
  , 1 ⊂ [1, 2]
  , 6 → [4 .. 6]
  , 3 ⊂ [0 .. 5]
  , 2 ⊂ [10, 11]
  , 1 ⊂ [6, 7, 8]
  , 4 ⊂ [0 .. 10]
  ]
  where
    (⊂), (→)  :: Int -> [Int] -> [Int] -> Bool
    (s ⊂ x) b = s == (sum . map (b !!) . takeWhile (< length b)) x
    (a → x) b = (b !! a == 0) || all ((== 1) . (b !!)) x

testall :: [[Int] -> Bool] -> Int -> [([Int], [Int])]
testall s n =
  [ (b, w)
  | b <- tf s
  , w <- [wrongness b s]
  , length w == n ]

main :: IO ()
main =
  let t = testall statements
  in do putStrLn "Answer"
        mapM_ print $ t 0
        putStrLn "Near misses"
        mapM_ print $ t 1
