import Data.List (foldl')

seriesSum :: Num a => (a -> a) -> [a] -> a
seriesSum f xs = foldl' (\a x -> a + (f x)) 0 xs

main :: IO()
main = putStrLn $ show $
    seriesSum (\x -> 1 / x ^ 2) [1..1000]
