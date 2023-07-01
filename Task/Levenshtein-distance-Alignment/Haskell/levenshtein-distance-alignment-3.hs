-- Produces all possible alignments for two strings.
allAlignments :: String -> String -> [[(Char, Char)]]
allAlignments s1 s2 = go (length s2 - length s1) s1 s2
  where
    go _ s [] = [(\x -> (x, '-')) <$> s]
    go _ [] s = [(\x -> ('-' ,x)) <$> s]
    go n s1@(h1:t1) s2@(h2:t2) = (h1, h2) <:> go n t1 t2
      ++ case compare n 0 of
           LT -> (h1, '-') <:> go (n+1) t1 s2
           EQ -> []
           GT -> ('-', h2) <:> go (n-1) s1 t2

    x <:> l = fmap (x :) l

-- Returns a lazy list of all optimal alignments.
levenshteinAlignments :: String -> String -> [(String, String)]
levenshteinAlignments s1 s2 = unzip <$> best
  where
    best = filter ((lev ==) . dist) $ allAlignments s1 s2
    lev = levenshteinDistance s1 s2
    dist = length . filter (uncurry (/=))
