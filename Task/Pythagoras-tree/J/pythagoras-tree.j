require'plot'

Pt=: {{
  if. 0<m do.
    d=. 0j1*y-x
    p2=. y+d
    p3=. x+d
    p4=. (0.5*x+y)+1.5*d
    pd x,y,p2,p3
    p3 (<:m) Pt p4
    p4 (<:m) Pt p2
  end.
}}


Pytree=: {{
  pd 'reset'
  pd 'type poly'
  5r2j4 y Pt 7r2j4
  pd 'show'
}}

Pytree 7
