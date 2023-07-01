NB. functionally equivalent translation of the Lua program found
NB. at https://en.wikipedia.org/wiki/Jacobi_symbol
jacobi=: {{
  assert. (0<x) * 1=2|x
  y=. x|y
  t=. 1
  while. y do.
    e=. (|.#:y) i.1
    y=. <.y%2^e
    t=. t*_1^(*/3 = 4|x,y)+(2|e)*(8|x) e.3 5
    'x y'=. y, y|x
  end.
  t*x=1
}}"0
