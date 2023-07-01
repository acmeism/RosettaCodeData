floydWarshall v dist = foldr innerCycle (Just <$> dist) v
  where
    innerCycle k dist = (newDist <$> v <*> v) `setTo` dist
      where
        newDist i j =
          ((i,j), do a <- join $ lookup (i, k) dist
                     b <- join $ lookup (k, j) dist
                     return $ Shortest (distance a <> distance b) (path a))

        setTo = unionWith (<>) . fromList
