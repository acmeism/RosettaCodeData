import Data.List (permutations)
import Control.Monad (guard)

dinesman :: [(Int,Int,Int,Int,Int)]
dinesman = do
  -- baker, cooper, fletcher, miller, smith are integers representing
  -- the floor that each person lives on, from 1 to 5

  -- Baker, Cooper, Fletcher, Miller, and Smith live on different floors
  -- of an apartment house that contains only five floors.
  [baker, cooper, fletcher, miller, smith] <- permutations [1..5]

  -- Baker does not live on the top floor.
  guard $ baker /= 5

  -- Cooper does not live on the bottom floor.
  guard $ cooper /= 1

  -- Fletcher does not live on either the top or the bottom floor.
  guard $ fletcher /= 5 && fletcher /= 1

  -- Miller lives on a higher floor than does Cooper.
  guard $ miller > cooper

  -- Smith does not live on a floor adjacent to Fletcher's.
  guard $ abs (smith - fletcher) /= 1

  -- Fletcher does not live on a floor adjacent to Cooper's.
  guard $ abs (fletcher - cooper) /= 1

  -- Where does everyone live?
  return (baker, cooper, fletcher, miller, smith)

main :: IO ()
main = do
  print $ head dinesman -- print first solution: (3,2,4,5,1)
  print dinesman -- print all solutions (only one): [(3,2,4,5,1)]
