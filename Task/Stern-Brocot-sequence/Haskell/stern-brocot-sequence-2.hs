import Data.List (nubBy, sortBy)
import Data.Ord (comparing)
import Data.Monoid ((<>))
import Data.Function (on)

sternBrocot :: [Int]
sternBrocot =
  let go (a:b:xs) = (b : xs) <> [a + b, b]
  in head <$> iterate go [1, 1]

-- TEST -------------------------------------------------------------
main :: IO ()
main = do
  print $ take 15 sternBrocot
  print $
    take 10 $
    nubBy (on (==) fst) $
    sortBy (comparing fst) $ takeWhile ((110 >=) . fst) $ zip sternBrocot [1 ..]
  print $ take 1 $ dropWhile ((100 /=) . fst) $ zip sternBrocot [1 ..]
  print $ (all ((1 ==) . uncurry gcd) . (zip <*> tail)) $ take 1000 sternBrocot
