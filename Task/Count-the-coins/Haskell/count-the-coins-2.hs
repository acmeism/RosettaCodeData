count :: Integral a => [Int] -> [a]
count = foldr addCoin (1 : repeat 0)
  where
    addCoin c oldlist = newlist
      where
        newlist = take c oldlist ++ zipWith (+) newlist (drop c oldlist)

main :: IO ()
main = do
  print (count [25, 10, 5, 1] !! 100)
  print (count [100, 50, 25, 10, 5, 1] !! 10000)
