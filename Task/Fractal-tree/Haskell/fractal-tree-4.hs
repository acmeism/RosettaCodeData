circles t = fractal 10 model $ Circle 100
  where model = [ Translate 0 50 . Scale 0.5 0.5 . Rotate t
                , Translate 0 (-50) . Scale 0.5 0.5 . Rotate (-2*t) ]
