import Data.List ((\\))
import System.Environment (getArgs)

prisoners :: Int -> [Int]
prisoners n = [0 .. n - 1]

counter :: Int -> [Int]
counter k = cycle [k, k-1 .. 1]

killList :: [Int] -> [Int] -> ([Int], [Int], [Int])
killList xs cs = (killed, survivors, newCs)
    where
        (killed, newCs) = kill xs cs []
        survivors = xs \\ killed
        kill [] cs rs = (rs, cs)
        kill (x:xs) (c:cs) rs
            | c == 1 =
                let ts = rs ++ [x]
                in  kill xs cs ts
            | otherwise =
                kill xs cs rs

killRecursive :: [Int] -> [Int] -> Int -> ([Int], [Int])
killRecursive xs cs m = killR ([], xs, cs)
    where
        killR (killed, remaining, counter)
            | length remaining <= m = (killed, remaining)
            | otherwise =
                let (newKilled, newRemaining, newCounter) =
                        killList remaining counter
                    allKilled = killed ++ newKilled
                in  killR (allKilled, newRemaining, newCounter)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [n, k, m] -> print $ snd $ killRecursive (prisoners (read n))
                        (counter (read k)) (read m)
        _         -> print $ snd $ killRecursive (prisoners 41) (counter 3) 1
