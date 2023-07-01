import System.Random (randomRIO)
import Data.Bool (bool)

knuthShuffle :: [a] -> IO [a]
knuthShuffle xs = (foldr swapped xs . zip [1 ..]) <$> randoms (length xs)

swapped :: (Int, Int) -> [a] -> [a]
swapped (i, j) xs =
  let go (a, b)
        | a == b = xs
        | otherwise =
          let (m, n) = bool (b, a) (a, b) (b > a)
              (l, hi:t) = splitAt m xs
              (ys, lo:zs) = splitAt (pred (n - m)) t
          in concat [l, lo : ys, hi : zs]
  in bool xs (go (i, j)) $ ((&&) . (i <) <*> (j <)) $ length xs

randoms :: Int -> IO [Int]
randoms x = mapM (randomRIO . (,) 0) [1 .. pred x]

main :: IO ()
main = knuthShuffle ['a' .. 'k'] >>= print
