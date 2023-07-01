-- A straightforward, inefficient implementation of the Burrows–Wheeler
-- transform, based on the description in the Wikipedia article.
--
-- Special characters are *not* used to indicate the start or end of sequences,
-- so all strings can be represented.

import Data.List ((!!), find, sort, tails, transpose)
import Data.Maybe (fromJust)
import Text.Printf (printf)

newtype BWT a = BWT [Val a]

bwt :: Ord a => [a] -> BWT a
bwt xs = let n  = length xs + 2
             ys = transpose $ sort $ take n $ tails $ cycle $ pos xs
         in BWT $ ys !! (n-1)

invBwt :: Ord a => BWT a -> [a]
invBwt (BWT xs) = let ys = iterate step (map (const []) xs) !! length xs
                  in unpos $ fromJust $ find ((== Post) . last) ys
  where step = sort . zipWith (:) xs


data Val a = In a | Pre | Post deriving (Eq, Ord)

pos :: [a] -> [Val a]
pos xs = Pre : map In xs ++ [Post]

unpos :: [Val a] -> [a]
unpos xs = [x | In x <- xs]


main :: IO ()
main = mapM_ testBWT [ "", "a", "BANANA", "dogwood",
                       "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
                       "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES" ]

testBWT :: String -> IO ()
testBWT xs = let fwd = bwt xs
                 inv = invBwt fwd
             in printf "%s\n\t%s\n\t%s\n" xs (pretty fwd) inv
  where pretty (BWT ps) = map prettyVal ps
        prettyVal (In c) = c
        prettyVal Pre    = '^'
        prettyVal Post   = '|'
