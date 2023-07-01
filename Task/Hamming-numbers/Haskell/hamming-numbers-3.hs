hammFrom n = drop n $
   iterate (\(_ , (a:t)) -> (a, union t [2*a,3*a,5*a])) (0, [1])
