import Data.Function (fix)

count
  :: Integral a
  => [Int] -> [a]
count =
  foldr
    (\x a ->
        let (l, r) = splitAt x a
        in fix ((<>) l . flip (zipWith (+)) r))
    (1 : repeat 0)

---------------------------- TEST --------------------------
main :: IO ()
main =
  mapM_
    (print . uncurry ((!!) . count))
    [ ([25, 10, 5, 1], 100)
    , ([100, 50, 25, 10, 5, 1], 10000)
    , ([100, 50, 25, 10, 5, 1], 1000000)
    ]
