import Data.Bits
import Text.Printf

gospersHack :: Int -> Int
gospersHack x =
    let c = x .&. (-x)
        r = x + c
    in ((r `xor` x) `shiftR` 2) `div` c .|. r

generateSequence :: Int -> Int -> [Int]
generateSequence start n = tail $ scanl (\x _ -> gospersHack x) start [1..n]

printGosperSeries :: Int -> IO ()
printGosperSeries start = do
    let results = generateSequence start 10
    printf "%2d:  %s\n" start (concatMap (\x -> show x ++ ", ") results)

main :: IO ()
main = mapM_ printGosperSeries [1, 3, 7, 15]

