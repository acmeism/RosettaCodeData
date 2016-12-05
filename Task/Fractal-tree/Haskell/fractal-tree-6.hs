pentaflake _ = fractal 5 model $ pentagon
  where model =  map copy [0,72..288]
        copy a = Scale s s . Rotate a . Translate 0 x
        pentagon = Line [ (sin a, cos a) | a <- [0,2*pi/5..2*pi] ]
        x = 2*cos(pi/5)
        s = 1/(1+x)
