subtractgen :: Int -> [Int]
subtractgen seed = drop 220 out
  where
    out = mmod $ r <> zipWith (-) out (drop 31 out)
      where
        r = take 55 $ shuffle $ cycle $ take 55 s
        shuffle x = (:) . head <*> shuffle $ drop 34 x
        s = mmod $ seed : 1 : zipWith (-) s (tail s)
        mmod = fmap (`mod` 10 ^ 9)

main :: IO ()
main = mapM_ print $ take 10 $ subtractgen 292929
