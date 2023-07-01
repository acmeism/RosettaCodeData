import Data.List (sort, subsequences)
comb m n = sort . filter ((==m) . length) $ subsequences [0..n-1]
