instance Comonad Cells where
  extract (Cells _ x _) = x
  duplicate x = Cells (rewind left x) x (rewind right x)
    where
      rewind dir = Inf.iterate dir . dir
      right (Cells l x (r ::: rs)) = Cells (x ::: l) r rs
      left  (Cells (l ::: ls) x r) = Cells ls l (x ::: r)

runCA rule = iterate (=>> step)
  where step (Cells (l ::: _) x (r ::: _)) = rule l x r
