[prime-decomposition
   [inner
       [dup * <]
           [pop unit]
           [ [% zero?]
                   [ [p c : [c p c / c]] view i inner cons]
                   [succ inner]
             ifte]
       ifte].
   2 inner].
