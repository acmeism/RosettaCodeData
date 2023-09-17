proc carp x y sz . .
   move x - sz / 2 y - sz / 2
   rect sz sz
   if sz > 0.5
      h = sz / 3
      carp x - sz y - sz h
      carp x - sz y h
      carp x - sz y + sz h
      carp x + sz y - sz h
      carp x + sz y h
      carp x + sz y + sz h
      carp x y - sz h
      carp x y + sz h
   .
.
background 000
clear
color 633
carp 50 50 100 / 3
