extendWith f [] = []
extendWith f xs@(x:ys) = x : zapWith f xs ys
