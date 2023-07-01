instance Monoid Elliptic where
  mempty = Zero

  mappend Zero p = p
  mappend p Zero = p
  mappend p@(Elliptic x1 y1) q@(Elliptic x2 y2)
    | p == inv q = Zero
    | p == q     = mkElliptic $ 3*x1^2/(2*y1)
    | otherwise  = mkElliptic $ (y2 - y1)/(x2 - x1)
    where
      mkElliptic l = let x = l^2 - x1 - x2
                         y = l*(x1 - x) - y1
                     in Elliptic x y
