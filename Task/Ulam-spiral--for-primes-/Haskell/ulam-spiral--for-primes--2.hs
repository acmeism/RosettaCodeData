swirl n = spool . take (2*(n-1)+1) . chop 1

chop n lst = let (x,(y,z)) = splitAt n <$> splitAt n lst
             in x:y:chop (n+1) z

spool = foldl (\table piece -> piece : rotate table) [[]]
  where rotate = reverse . transpose
