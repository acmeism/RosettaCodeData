stableMatching :: Eq a => State a -> [Couple a]
stableMatching = getPairs . until (null._freeGuys) step
  where
    getPairs s = map (_2 %~ head) $ s^.guys

step :: Eq a => State a -> State a
step s = foldl propose s (s^.freeGuys)
  where
    propose s guy =
      let girl                = s^.fianceesOf guy & head
          bestGuy : otherGuys = s^.fiancesOf girl
          modify
            | guy == bestGuy       = freeGuys %~ delete guy
            | guy `elem` otherGuys = (fiancesOf girl %~ dropWhile (/= guy)) .
                                     (freeGuys %~ guy `replaceBy` bestGuy)
            | otherwise            = fianceesOf guy %~ tail
      in modify s

    replaceBy x y [] = []
    replaceBy x y (h:t) | h == x = y:t
                        | otherwise = h:replaceBy x y t

unstablePairs :: Eq a => State a -> [Couple a] -> [(Couple a, Couple a)]
unstablePairs s pairs =
  [ ((m1, w1), (m2,w2)) | (m1, w1) <- pairs
                        , (m2,w2) <- pairs
                        , m1 /= m2
                        , let fm = s^.fianceesOf m1
                        , elemIndex w2 fm < elemIndex w1 fm
                        , let fw = s^.fiancesOf w2
                        , elemIndex m2 fw < elemIndex m1 fw ]
