halfAdder = uncurry band &&& uncurry xor
fullAdder (c, a, b) =  (\(cy,s) ->  first (bor cy) $ halfAdder (b, s)) $ halfAdder (c, a)

adder4 as = mapAccumR (\cy (f,a,b) -> f (cy,a,b)) 0 . zip3 (replicate 4 fullAdder) as
