import Control.Monad (replicateM)
import Data.List (group, sort)

succeeds :: (Int, Int) -> (Int, Int) -> Double
succeeds p1 p2 =
  sum
    [ realToFrac (c1 * c2) / totalOutcomes
    | (s1, c1) <- countSums p1
    , (s2, c2) <- countSums p2
    , s1 > s2 ]
  where
    totalOutcomes = realToFrac $ uncurry (^) p1 * uncurry (^) p2
    countSums (nFaces, nDice) = f [1 .. nFaces]
      where
        f =
          fmap (((,) . head) <*> (pred . length)) .
          group . sort . fmap sum . replicateM nDice

main :: IO ()
main = do
  print $ (4, 9) `succeeds` (6, 6)
  print $ (10, 5) `succeeds` (7, 6)
