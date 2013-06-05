import Control.Monad (foldM)
import Data.List ((\\))

main :: IO ()
main = mapM_ print $ queens 8

queens :: Int -> [[Int]]
queens n = foldM f [] [1..n]
    where
      f qs k = [q:qs | q <- [1..n] \\ qs, q `notDiag` qs]
      q `notDiag` qs = and [abs (q - qi) /= i | (qi,i) <- qs `zip` [1..]]
