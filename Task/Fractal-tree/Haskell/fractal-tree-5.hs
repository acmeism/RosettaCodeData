pithagor _ = fractal 10 model $ rectangleWire 100 100
  where model = [ Translate 50 100 . Scale s s . Rotate 45
                , Translate (-50) 100 . Scale s s . Rotate (-45)]
        s = 1/sqrt 2
