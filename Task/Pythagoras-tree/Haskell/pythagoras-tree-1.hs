mkBranches :: [(Float,Float)] -> [[(Float,Float)]]
mkBranches [a, b, c, d] = let d  = 0.5 <*> (b <+> (-1 <*> a))
                              l1 = d <+> orth d
                              l2 = orth l1
                    in
                      [ [a <+> l2, b <+> (2 <*> l2), a <+> l1, a]
                      , [a <+> (2 <*> l1), b <+> l1, b, b <+> l2] ]
  where
    (a, b) <+> (c, d) = (a+c, b+d)
    n <*> (a, b) = (a*n, b*n)
    orth (a, b) = (-b, a)
