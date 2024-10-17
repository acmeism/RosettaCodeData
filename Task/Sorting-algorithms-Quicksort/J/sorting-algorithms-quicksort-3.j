sel=: 1 : 'u # ]'

quicksort=: 3 : 0
 if.
  1 >: #y
 do.
  y
 else.
  p=. y{~?#y
  (quicksort y <sel p),(y =sel p),quicksort y >sel p
 end.
)
