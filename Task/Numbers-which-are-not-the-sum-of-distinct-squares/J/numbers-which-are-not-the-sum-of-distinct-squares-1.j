task=: {{
  r=. 'invalid'
  lim=. 1
  whilst. -.r -: have do.
    have=. r
    lim=. lim+1
    r=. (i.*:lim) -. (#:i.2^lim)+/ .**:i.lim
  end.
}}
