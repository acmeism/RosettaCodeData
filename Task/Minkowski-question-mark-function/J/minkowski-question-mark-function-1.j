ITERCOUNT=: 52

minkowski=: {{
  f=. 1|y
  node=. *i.2 2 NB. node of Stern-Brocot tree
  B=. ''
  for. i.ITERCOUNT do.
    B=. B, b=. f>:%/t=. +/node
    node=. t (1-b)} node
  end.
  (<.y)+B+/ .*2^-1+i.ITERCOUNT
}}

invmink=: {{
  f=. 1|y
  cf=. i.0
  cur=. 0 NB. 1 if generating "top" side of cf
  cnt=. 1 NB. proposed continued fraction element
  for. i.ITERCOUNT do.
    if. f=<. f do.
      cf=. cf,%cnt break.
    end.
    f=. f*2
    b=. 1 >`<@.cur f
    cf=. cf,(-.b)#cnt
    cnt=. 1+b*cnt
    cur=. cur=b
    f=. f-cur
  end.
  (+%)/(<.y),cf
}}
