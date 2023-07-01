import System.Random

instance RandomGen (Cycle Int) where
  next c =
    let x = c =>> step (rule 30)
     in (fromBits (view x), x)
  split = (,) <*> (fromList . reverse . view)
