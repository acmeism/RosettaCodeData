insert=: {{
  X=.1 {::2{.x,x  NB. middle element of x (don't fail on empty x)
  Y=.1 {::2{.y,y  NB. middle element of y (don't fail on empty y)
  select.#y
    case.0 do.x   NB. y is an empty node
    case.1 do.    NB. y is a leaf node
      select.*Y-X
        case._1 do.a:,y;<x
        case. 0 do.y
        case. 1 do.x;y;a:
      end.
    case.3 do.   NB. y is a parent node
      select.*Y-X
        case._1 do.balance (}:y),<x insert 2{::y
        case. 0 do.y
        case. 1 do.balance (x insert 0{::y);}.y
      end.
  end.
}}

delete=: {{
  select.#y
    case.0 do.y
    case.1 do.y-.x
    case.3 do.
      select.*(1{::y)-x
        case._1 do.balance (}:y),<x delete 2{::y
        case. 0 do.balance (0{::y) insert 2{::y
        case. 1 do.balance (x delete 0{::y);}.y
      end.
    end.
}}

lookup=: {{
  select.#y
    case.0 do.y
    case.1 do.if.x=y do.y else.'' end.
    case.3 do.
      select.*(1{::y)-x
        case._1 do.x lookup 2{::y
        case. 0 do.y
        case. 1 do.x lookup 0{::y
      end.
  end.
}}

clean=: {{
  's0 x s2'=. #every y
  if.*/0=s0,s2 do. 1{:: y NB. degenerate to leaf
  else. y end.
}}

balance=: {{
  if. 2>#y do. y return.end. NB. leaf or empty
  's0 x s2'=. ,#every y
  if. */0=s0,s2 do. 1{:: y return.end. NB. degenerate to leaf
  'l0 x l2'=. L.every y
  if. 2>|l2-l0 do. y return.end. NB. adequately balanced
  if. l2>l0 do.
    'l20 x l22'=. L.every 2{::y
    if. l22 >: l20 do. rotLeft y
    else. rotRightLeft y end.
  else.
    'l00 x l02'=. L.every 0{::y
    if. l00 >: l02 do. rotRight y
    else. rotLeftRight y end.
  end.
}}

rotLeft=: {{
  't0 t1 t2'=. y
  't20 t21 t22'=. t2
  (clean t0;t1;<t20);t21;<t22
}}

rotRight=: {{
  't0 t1 t2'=. y
  't00 t01 t02'=. t0
  t00;t01;<clean t02;t1;<t2
}}

rotRightLeft=: {{
  't0 t1 t2'=. y
  rotLeft t0;t1;<rotRight t2
}}

rotLeftRight=: {{
  't0 t1 t2'=. y
  rotRight (rotLeft t0);t1;<t2
}}
