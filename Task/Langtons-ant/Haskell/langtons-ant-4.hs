step :: State -> State
step = isBlack ?>> (setWhite >>> turnRight,
                    setBlack >>> turnLeft) >>> move
  where
    isBlack   (State p _     m) = member p m
    setBlack  (State p d     m) = State p d (insert p m)
    setWhite  (State p d     m) = State p d (delete p m)
    turnRight (State p (x,y) m) = State p (y,-x) m
    turnLeft  (State p (x,y) m) = State p (-y,x) m
    move (State (x,y) (dx,dy) m) = State (x+dx, y+dy) (dx, dy) m
