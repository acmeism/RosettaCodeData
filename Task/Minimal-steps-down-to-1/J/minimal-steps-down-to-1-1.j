step=: {{
  ~.((#~ 1<:]),y-/m),(#~ (=<.)),y%/n
}}

steps=: {{
  m step n^:(1 - 1 e. ])^:a:
}}

show=: {{
  paths=.,:,:0 0 1   NB. operator, operand, net value
  m=.,m [ n=.,n      NB. m: subtractors, n: divisors
  for_ok.}.|.m steps n y do.  NB. ok: valid net values
    last=.{."2 paths
    subs=. (1,.m,.0)+"2]0 0 1*"1 last+"1 0/m
    divs=. (2,.n,.0)+"2]0 0 1*"1 last*"1 0/n
    prev=. subs,"2 divs   NB. we are working backwards from 1
    paths=. (,({:"1 prev)e.ok)#,/prev,"1 2/"2 paths
  end.
  ;@((<":y),,)"2((' -/'{~{.);":@{:)"1}:"2}:"1 paths
}}
