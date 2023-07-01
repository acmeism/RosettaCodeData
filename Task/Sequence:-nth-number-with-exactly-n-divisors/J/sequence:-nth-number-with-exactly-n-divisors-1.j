A073916=: {{
  if.1 p: y do. (p:^x:)y-1 return.
  elseif.1|y do.
    f= *:
  else.
    f=. ]
  end. r=.i.0
  off=. 1
  while. y>#r do.
    r=. r,f off+I.y=*/|:1+_ q:f off+i.y
    off=. off+y
  end.
  (y-1){r
}}"0
