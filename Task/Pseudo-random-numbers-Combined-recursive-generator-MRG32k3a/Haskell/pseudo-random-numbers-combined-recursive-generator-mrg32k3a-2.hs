import System.Random

newtype MRG32k3a = MRG32k3a ([Int],[Int])

mkMRG32k3a s = MRG32k3a ([s,0,0],[s,0,0])

instance RandomGen MRG32k3a where
  next (MRG32k3a (x1,x2)) =
    let x1i = sum (zipWith (*) x1 a1) `mod` m1
        x2i = sum (zipWith (*) x2 a2) `mod` m2
    in ((x1i - x2i) `mod` m1, MRG32k3a (x1i:init x1, x2i:init x2))
    where
      a1 = [0, 1403580, -810728]
      m1 = 2^32 - 209
      a2 = [527612, 0, -1370589]
      m2 = 2^32 - 22853

  split _ = error "MRG32k3a is not splittable"
