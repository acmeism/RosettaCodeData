tree2 t = fractal 8 branches $ Line [(0,0),(0,100)]
  where branches = [ Translate 0 100 . Scale 0.75 0.75 . Rotate t
                   , Translate 0 100 . Scale 0.6 0.6 . Rotate 0
                   , Translate 0 100 . Scale 0.5 0.5 . Rotate (-2*t) ]
