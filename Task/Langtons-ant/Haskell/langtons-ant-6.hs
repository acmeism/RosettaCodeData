import Graphics.Gloss

main = display w white (draw (task initial))
  where
    w = InWindow "Langton's Ant" (400,400) (0,0)
    initial = State (0,0) (1,0) mempty
    draw = foldMap drawCell
    drawCell (x,y) = Translate (10*x) (10*y) $ rectangleSolid 10 10
