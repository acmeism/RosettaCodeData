main = simulate w white 500 initial draw (\_ _ -> step)
  where
    w = InWindow "Langton's Ant" (400,400) (0,0)
    initial = State (0,0) (1,0) mempty
    draw (State p _ s) = pictures [foldMap drawCell s, color red $ drawCell p]
    drawCell (x,y) = Translate (10*x) (10*y) $ rectangleSolid 10 10
