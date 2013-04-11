halfAdder = uncurry band &&& uncurry xor
fullAdder (c, a, b) =  (\(cy,s) ->  first (bor cy) $ halfAdder (b, s)) $ halfAdder (c, a)

adder4 as = foldr (\(f,a,b) (cy,bs) -> second(:bs) $ f (cy,a,b)) (0,[]). zip3 (replicate 4 fullAdder) as
