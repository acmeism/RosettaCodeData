import Data.List (unfoldr)

yellowstone :: [Integer]
yellowstone = 1 : 2 : 3 : unfoldr (Just . f) (2, 3, [4 ..])
  where
    f ::
      (Integer, Integer, [Integer]) ->
      (Integer, (Integer, Integer, [Integer]))
    f (p2, p1, rest) = (next, (p1, next, rest_))
      where
        (next, rest_) = select rest
        select :: [Integer] -> (Integer, [Integer])
        select (x : xs)
          | gcd x p1 == 1 && gcd x p2 /= 1 = (x, xs)
          | otherwise = (y, x : ys)
          where
            (y, ys) = select xs

main :: IO ()
main = print $ take 30 yellowstone
