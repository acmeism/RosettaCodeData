--animated tree
tree2 t = fractal 8 branches $ Line [(0,0),(0,100)]
  where branches = [ Translate 0 100 . Scale 0.75 0.75 . Rotate t
                   , Translate 0 100 . Scale 0.6 0.6 . Rotate 0
                   , Translate 0 100 . Scale 0.5 0.5 . Rotate (-2*t) ]

--animated fractal clock
circles t = fractal 10 model $ Circle 100
  where model = [ Translate 0 50 . Scale 0.5 0.5 . Rotate t
                , Translate 0 (-50) . Scale 0.5 0.5 . Rotate (-2*t) ]

--Pythagoras tree
pithagor _ = fractal 10 model $ rectangleWire 100 100
  where model = [ Translate 50 100 . Scale s s . Rotate 45
                , Translate (-50) 100 . Scale s s . Rotate (-45)]
        s = 1/sqrt 2

--Sierpinski pentagon
pentaflake _ = fractal 5 model $ pentagon
  where model =  map copy [0,72..288]
        copy a = Scale s s . Rotate a . Translate 0 x
        pentagon = Line [ (sin a, cos a) | a <- [0,2*pi/5..2*pi] ]
        x = 2*cos(pi/5)
        s = 1/(1+x)
