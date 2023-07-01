main = putStrLn $ toList l
  where l = mcons 'M' n1 n2 x
        x = rcons 'Z' $ fcons 'a' $ fcons 'q' $ singleton 'w'
        n1 = firstNode x
        Just n2 = nextNode x n1
