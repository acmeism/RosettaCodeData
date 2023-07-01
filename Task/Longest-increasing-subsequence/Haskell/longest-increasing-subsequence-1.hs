import Data.Ord          ( comparing )
import Data.List         ( maximumBy, subsequences )
import Data.List.Ordered ( isSorted, nub )

lis :: Ord a => [a] -> [a]
lis = maximumBy (comparing length) . map nub  . filter isSorted . subsequences
--    longest                    <-- unique <-- increasing    <-- all

main = do
  print $ lis [3,2,6,4,5,1]
  print $ lis [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]
  print $ lis [1,1,1,1]
