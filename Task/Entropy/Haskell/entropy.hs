import Data.List

main = print $ entropy "1223334444"

entropy :: (Ord a, Floating c) => [a] -> c
entropy = sum . map lg . fq . map genericLength . group . sort
  where lg c = -c * logBase 2 c
        fq c = let sc = sum c in map (/ sc) c
