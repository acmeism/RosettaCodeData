: equilibrium(l)
| ls rs i e |
   0 ->ls
   l sum ->rs
   ListBuffer new l size loop: i [
      l at(i) ->e
      rs e - dup ->rs ls == ifTrue: [ i over add ]
      ls e + ->ls
      ] ;
