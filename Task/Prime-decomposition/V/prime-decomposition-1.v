[prime-decomposition
   [inner [c p] let
       [c c * p >]
           [p unit]
           [ [p c % zero?]
                   [c c p c / inner cons]
                   [c 1 + p inner]
             ifte]
       ifte].
   2 swap inner].
