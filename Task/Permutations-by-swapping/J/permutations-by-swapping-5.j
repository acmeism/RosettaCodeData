rsjt=: 3 :0
  if. 2>y do. i.2#y
  else.  ((!y)$(,~|.)-.=i.y)#inv!.(y-1)"1 y#rsjt y-1
  end.
)
