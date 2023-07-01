import Control.Applicative

bellTri :: [[Integer]]
bellTri = map snd (iterate ((liftA2 (,) last id) . uncurry (scanl (+))) (1,[1]))
