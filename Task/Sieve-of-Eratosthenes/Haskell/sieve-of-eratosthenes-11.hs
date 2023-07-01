primesB = _Y ( (2:) . minus [3..] . foldr (\p-> (p*p :) . union [p*p+p, p*p+2*p..]) [] )

--      = _Y ( (2:) . minus [3..] . _LU . map(\p-> [p*p, p*p+p..]) )
-- _LU ((x:xs):t) = x : (union xs . _LU) t             -- linear folding big union

_Y g = g (_Y g)  -- = g (g (g ( ... )))      non-sharing multistage fixpoint combinator
--                  = g . g . g . ...            ... = g^inf
--   = let x = g x in g x -- = g (fix g)     two-stage fixpoint combinator
--   = let x = g x in x   -- = fix g         sharing fixpoint combinator

union a@(x:xs) b@(y:ys) = case compare x y of
         LT -> x : union  xs b
         EQ -> x : union  xs ys
         GT -> y : union  a  ys
