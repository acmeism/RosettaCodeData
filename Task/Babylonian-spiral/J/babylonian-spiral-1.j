require'stats'
bspir=: {{
  r=. 0
  e=. 2>.<.+:%:y
  for_qd.
    (y-1){.(</.~ *:@|) (/:|) (#~ (=<.)@:*:@:|) j./"1 (2 comb e),,.~1+i.e
  do.
    d=. ~.(,+)(,-)(,j.);qd
    ar=. 12 o. -~/_2{.r
    ad=. (- 2p1 * >:&ar) 12 o. d
    -r=. r, ({:r)+d{~ (i. >./) ad
  end.
}}
