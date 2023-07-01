-- the Sierpinsky`s triangle
triangle = [ (mid (0, 0), 1)
           , (mid (1, 0), 1)
           , (mid (0.5, 0.86), 1) ]
  where mid (a,b) (x,y) = ((a+x)/2, (b+y)/2)

-- the Barnsley's fern
fern = [(f1, 1), (f2, 85), (f3, 7), (f4, 7)]
  where f1 (x,y) = (0, 0.16*y)
        f2 (x,y) = (0.85*x + 0.04*y, -0.04*x + 0.85*y + 1.6)
        f3 (x,y) = (0.2*x - 0.26*y, 0.23*x + 0.22*y + 1.6)
        f4 (x,y) = (-0.15*x + 0.28*y, 0.26*x + 0.24*y + 0.44)

-- A dragon curve
dragon = [(f1, 1), (f2, 1)]
  where f1 (x,y) = (0.5*x - 0.5*y, 0.5*x + 0.5*y)
        f2 (x,y) = (-0.5*x + 0.5*y+1, -0.5*x - 0.5*y)
