krsieve=: {{
  for_i. i.<.-:#b=. (1+y){.0 1 do.
    if. i{b do. b=. 1 ((#~ y&>)1+2 3*i)} b end.
  end.
  I.b
}}
