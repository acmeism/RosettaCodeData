alignment :: String -> String -> (String, String)
alignment s1 s2 = go (costs s1 s2) (reverse s1) (reverse s2) ([],[])
  where
    go c _ _ r | isEmpty c = r
    go _ [] s r = ('-' <$ s, reverse s) <> r
    go _ s [] r = (reverse s, '-' <$ s) <> r
    go c s1@(h1:t1) s2@(h2:t2) (r1, r2) =
      let temp = (get.nextCol.nextRow $ c) + if h1 == h2 then 0 else 1
      in case get c of
        x | x == temp -> go (nextRow.nextCol $ c) t1 t2 (h1:r1, h2:r2)
          | x == 1 + (get.nextCol $ c) -> go (nextCol c) s1 t2 ('-':r1, h2:r2)
          | x == 1 + (get.nextRow $ c) -> go (nextRow c) t1 s2 (h1:r1, '-':r2)

    -- Functions which treat table as zipper
    get ((h:_):_) = h
    nextRow = map tail
    nextCol = tail
    isEmpty c = null c || null (head c)
