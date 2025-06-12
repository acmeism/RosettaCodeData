proc carp x y sz .
   grect x - sz / 2 y - sz / 2 sz sz
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
gbackground 000
gclear
gcolor 633
carp 50 50 100 / 3
