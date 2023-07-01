ambsel=: <^:99@,

ambassert=: {{
  anames=. (#~ 99<:{{L.do y}}@>) (#~ 0=nc)/:~~.;:m
  limit=. */alimits=. #@> avalues=. {{>^:98 do y}}every anames
  j=. 0 while. do.
    (anames)=. test=. (alimits#:j) {each avalues
    try. do m
      anames {{(x)=:y}}&> test break.
    catch. end.
    if. limit<:j=.j+1 do. assert.'no valid solution' end.
  end. EMPTY
}}
