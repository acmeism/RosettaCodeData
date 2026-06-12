nadd=: 22 b.  NB. bitwise exclusive or on integers
and=:  17 b.  NB. bitwise exclusive or on integers

nmul=: {{
  if. x +.&(2&>) y do.
    x*y
  elseif. 1 < #_ q: x do.
    h=. (and-) x
    (h nmul y) nadd y nmul h nadd x
  elseif. 1 < #_ q: y do.
    y nmul x
  else.
    comp=. x and&(0 { 1 q: ]) y
    if. 0=comp do.
      x*y
    else.
      p=. 2^(and-) comp
      (3*p%2) nmul x nmul&(%&p) y
    end.
  end.
}}M."0
