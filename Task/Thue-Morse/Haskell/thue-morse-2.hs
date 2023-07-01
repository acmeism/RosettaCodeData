thueMorse :: [Int]
thueMorse = 0 : g 1
  where
    g i = (1 -) <$> take i thueMorse <> g (2 * i)

main :: IO ()
main = print $ take 33 thueMorse
