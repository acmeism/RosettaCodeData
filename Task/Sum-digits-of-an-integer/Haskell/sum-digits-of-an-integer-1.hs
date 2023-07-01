digsum
  :: Integral a
  => a -> a -> a
digsum base = f 0
  where
    f a 0 = a
    f a n = f (a + r) q
      where
        (q, r) = n `quotRem` base

main :: IO ()
main = print $ digsum 16 255 -- "FF": 15 + 15 = 30
