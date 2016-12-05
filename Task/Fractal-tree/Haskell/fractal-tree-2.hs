tree1 _ = fractal 10 branches $ Line [(0,0),(0,100)]
  where branches = [ Translate 0 100 . Scale 0.75 0.75 . Rotate 30
                   , Translate 0 100 . Scale 0.5 0.5 . Rotate (-30) ]
