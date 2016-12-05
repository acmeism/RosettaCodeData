'names values'=:|:".;._2]0 :0
    'sunscreen'; 15 2
    'GPS'; 25 2
    'beer'; 35 3
)

X=: +/ .*"1
plausible=: (] (] #~ 40 >: X) #:@i.@(2&^)@#)@:({."1)
best=: (plausible ([ {~  [ (i. >./)@:X {:"1@]) ]) values
