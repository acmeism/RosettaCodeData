powerset [] = [[]]
powerset (head:tail) = acc ++ map (head:) acc where acc = powerset tail
