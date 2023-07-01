-- Some elementary types for Turing Machine
data Move = MLeft | MRight | Stay deriving (Show, Eq)
data Tape a = Tape a [a] [a]
data Action state val = Action val Move state deriving (Show)

instance (Show a) => Show (Tape a) where
  show (Tape x lts rts) = concat $ left ++ [hd] ++ right
                          where hd = "[" ++ show x ++ "]"
                                left = map show $ reverse $ take 10 lts
                                right = map show $ take 10 rts

-- new tape
tape blank lts rts | null rts = Tape blank left blanks
                   | otherwise = Tape (head rts) left right
                   where blanks = repeat blank
                         left = reverse lts ++ blanks
                         right = tail rts ++ blanks

-- Turing Machine
step rules (state, Tape x (lh:lts) (rh:rts)) = (state', tape')
     where  Action x' dir state' = rules state x
            tape' = move dir
            move Stay = Tape x' (lh:lts) (rh:rts)
            move MLeft = Tape lh lts (x':rh:rts)
            move MRight = Tape rh (x':lh:lts) rts

runUTM rules stop start tape = steps ++ [final]
      where (steps, final:_) = break ((== stop) . fst) $ iterate (step rules) (start, tape)
