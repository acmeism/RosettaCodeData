quickselect=:4 :0
  if. 0=#y do. _ return. end.
  n=.?#y
  m=.n{y
  if. x < m do.
    x quickselect (m>y)#y
  else.
    if. x > m do.
      x quickselect (m<y)#y
    else.
      m
    end.
  end.
)
