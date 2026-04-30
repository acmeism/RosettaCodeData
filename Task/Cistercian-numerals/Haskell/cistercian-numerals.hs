import Data.Bits
import Data.Char

bitflip :: Int -> Int
bitflip x = sum [bit (5 - i) | i <- [0 .. 5], testBit x i]

digits :: [[Int]]
digits =
 [ [0,0,0,0,0]      -- 0
 , [1,1,1,1,1]      -- 1
 , [16,16,16,16,16] -- 2
 , [1,2,4,8,16]     -- 3
 , [16,8,4,2,1]     -- 4
 , [17,9,5,3,1]     -- 5
 , [0,0,0,0,31]     -- 6
 , [1,1,1,1,31]     -- 7
 , [16,16,16,16,31] -- 8
 , [17,17,17,17,31] -- 9
 ]

digits10   = map reverse digits
digits100  = map (map bitflip) digits
digits1000 = map reverse digits100

showCisterian :: Int -> IO ()
showCisterian x =
  do
    putStr "\27Pq\"3;1;12;33"
    body $ digits10 !! d1
    body $ [63]
    body $ digits !! d0
    putChar '-'
    body $ digits1000 !! d3
    body $ [63]
    body $ digits100 !! d2
    putStrLn "\27\\\n\n"
  where
    [d3,d2,d1,d0] = map digitToInt $ tail $ show (x + 10000)
    body = putStr . concatMap (replicate 3 . toEnum . (0x3f +))

main = mapM_ (\x -> print x >> showCisterian x) [0,1,20,300,4000,5555,6789,3579]
