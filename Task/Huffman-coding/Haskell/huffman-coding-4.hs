import Data.List (sortBy, insertBy, sort, group)
import Control.Arrow (second, (&&&))
import Data.Ord (comparing)

freq :: Ord a => [a] -> [(Int, a)]
freq = map (length &&& head) . group . sort

huffman :: [(Int, Char)] -> [(Char, String)]
huffman = reduce . map (\(p, c) -> (p, [(c ,"")])) . sortBy (comparing fst)
  where add (p1, xs1) (p2, xs2) = (p1 + p2, map (second ('0':)) xs1 ++ map (second ('1':)) xs2)
        reduce [(_, ys)]  = sortBy (comparing fst) ys
        reduce (x1:x2:xs) = reduce $ insertBy (comparing fst) (add x1 x2) xs

test s = mapM_ (\(a, b) -> putStrLn ('\'' : a : "\' : " ++ b)) . huffman . freq $ s

main = do
    test "this is an example for huffman encoding"
