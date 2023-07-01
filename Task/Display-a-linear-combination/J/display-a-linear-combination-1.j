fourbanger=:3 :0
  e=. ('e(',')',~])@":&.> 1+i.#y
  firstpos=. 0< {.y-.0
  if. */0=y do. '0' else. firstpos}.;y gluedto e end.
)

gluedto=:4 :0 each
  pfx=. '+-' {~ x<0
  select. |x
    case. 0 do. ''
    case. 1 do. pfx,y
    case.   do. pfx,(":|x),'*',y
  end.
)
