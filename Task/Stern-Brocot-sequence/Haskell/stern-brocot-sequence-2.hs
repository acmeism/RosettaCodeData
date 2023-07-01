import Data.Function (on)
import Data.List (nubBy, sortOn)
import Data.Ord (comparing)

------------------ STERN-BROCOT SEQUENCE -----------------

sternBrocot :: [Int]
sternBrocot = head <$> iterate go [1, 1]
  where
    go (a : b : xs) = (b : xs) <> [a + b, b]

--------------------------- TEST -------------------------
main :: IO ()
main = do
  print $ take 15 sternBrocot
  print $
    take 10 $
      nubBy (on (==) fst) $
        sortOn fst $
          takeWhile ((110 >=) . fst) $
            zip sternBrocot [1 ..]
  print $
    take 1 $
      dropWhile ((100 /=) . fst) $
        zip sternBrocot [1 ..]
  print $
    (all ((1 ==) . uncurry gcd) . (zip <*> tail)) $
      take 1000 sternBrocot
