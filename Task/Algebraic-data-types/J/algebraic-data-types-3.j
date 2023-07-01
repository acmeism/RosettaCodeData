NB. always treat root of tree as black
validate=: {{
  if. 0=#y do. 1 return. end.
  'C e K w'=. y
  check 'B';e;K;<w
}}

check=: {{
  if. 0=#y do. 1 return. end.
  'C e K w'=. y
  if. 'R'=C do.
    if. 'R'={.;{.e do. 0 return. end.
    if. 'R'={.;{.w do. 0 return. end.
  end.
  a=. check e
  b=. check w
  (*a)*(a=b)*b+'B'=C
}}
