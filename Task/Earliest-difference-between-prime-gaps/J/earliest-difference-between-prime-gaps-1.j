lowpgap=: {{
  magnitude=. ref=. 10^y
  whilst. -.1 e. ok do.
    magnitude=. 10*magnitude
    g=. 2-~/\ p=.p: i.magnitude
    mag=. p{~}.g i. i.&.-: >./g NB. minimum adjacent gaps
    dif=. 2-~/\ mag
    ok=. ref < dif
  end.
  (0 1+ok i.1){mag
}}
