-- only for pretty print
import Text.Printf
import Control.Monad

generateZZ :: Int -> [[Int]]
generateZZ n = [ k : res | k <- [1 .. n], res <- up [1 .. pred k] [succ k .. n]]
  where
    up [] [] = [[]]
    up as bs = [ x : res | x <- bs, res <- dn (as ++ takeWhile (x >) bs) (dropWhile (x >=) bs) ]
    dn [] [] = [[]]
    dn as bs = [ x : res | x <- as, res <- up (takeWhile (x >) as) (dropWhile (x >=) as ++ bs) ]

countZZ :: Int -> Integer
countZZ n = sum [go !! a !! b | a <- [0 .. n], let b = pred n - a, b >= 0]
  where
    go = [[gof a b | b <- [0 ..]] | a <- [0 ..]]
    gof 0 0 = 1
    gof a b = sum [go !! d !! c | k <- [0 .. pred b], let c = a + k, let d = pred b - k, c >= 0, d >= 0]

main :: IO ()
main = do
  forM_ [1 .. 5] (\n -> do
    printf "Zigzag Permutations for N = %d:\n" n
    print $ generateZZ n
    )
  putStrLn "\n N   Zigzags"
  putStrLn $ replicate 30 '-'
  forM_ [1 .. 30] (\m -> printf "%2d   %d\n" m (countZZ m))
