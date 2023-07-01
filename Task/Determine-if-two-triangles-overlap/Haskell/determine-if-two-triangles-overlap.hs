isOverlapping :: Triangle Double -> Triangle Double -> Bool
isOverlapping t1 t2 = vertexInside || midLineInside
  where
    vertexInside =
      any (isInside t1) (vertices t2) ||
      any (isInside t2) (vertices t1)

    isInside t = (Outside /=) . overlapping t

    midLineInside =
      any (\p -> isInside t1 p && isInside t2 p) midPoints

    midPoints =
      [ intersections l1 l2 | l1 <- midLines t1
                            , l2 <- midLines t2 ]

    intersections (a1,b1,c1) (a2,b2,c2) =
      ( -(-b2*c1+b1*c2)/(a2*b1-a1*b2)
      , -(a2*c1-a1*c2)/(a2*b1-a1*b2) )

    midLines (Triangle a b c) =
      [line a b c, line b c a, line c a b]

    line (x,y) (ax, ay) (bx, by) =
      (ay+by-2*y, -ax-bx+2*x, -ay*x-by*x+ax*y+bx*y)

test = map (uncurry isOverlapping)
  [ (Triangle (0,0) (5,0) (0,5), Triangle (0,0) (5,0) (0,6))
  , (Triangle (0,0) (0,5) (5,0), Triangle (0,0) (0,5) (5,0))
  , (Triangle (0,0) (5,0) (0,5), Triangle (-10,0) (-5,0) (-1,6))
  , (Triangle (0,0) (5,0) (2.5,5), Triangle (0,4) (2.5,-1) (5,4))
  , (Triangle (0,0) (1,1) (0,2), Triangle (2,1) (3,0) (3,2))
  , (Triangle (0,0) (1,1) (0,2), Triangle (2,1) (3,-2) (3,4))
  , (Triangle (0,0) (1,0) (0,1), Triangle (1,0) (2,0) (1,1))]
