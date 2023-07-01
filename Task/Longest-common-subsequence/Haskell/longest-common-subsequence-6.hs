import Data.Ord
import Data.List

--          longest                        common
lcs xs ys = maximumBy (comparing length) $ intersect (subsequences xs) (subsequences ys)

main = print $ lcs "thisisatest" "testing123testing"
