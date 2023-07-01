import Control.Arrow

bellTri :: [[Integer]]
bellTri = map snd (iterate ((last &&& id) . uncurry (scanl (+))) (1,[1]))
