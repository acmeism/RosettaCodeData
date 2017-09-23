import Data.List (permutations, inits)

import Control.Arrow (first)

derangements :: [Int] -> [[Int]]
derangements = (filter . (and .) . zipWith (/=)) <*> permutations

topswop :: Int -> [a] -> [a]
topswop = ((uncurry (++) . first reverse) .) . splitAt

topswopIter :: [Int] -> [[Int]]
topswopIter = takeWhile ((/= 1) . head) . iterate (topswop =<< head)

swops :: [Int] -> [Int]
swops = fmap (length . topswopIter) . derangements

topSwops :: [Int] -> [(Int, Int)]
topSwops = zip [1 ..] . fmap (maximum . (0 :) . swops) . tail . inits

main :: IO ()
main = mapM_ print $ take 10 $ topSwops [1 ..]
