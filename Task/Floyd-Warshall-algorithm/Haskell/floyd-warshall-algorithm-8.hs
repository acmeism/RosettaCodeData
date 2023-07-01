showShortestPaths v g = mapM_ print $ toList $ findMinDistances v g
