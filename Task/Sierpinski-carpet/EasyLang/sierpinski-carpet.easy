proc carp x y sz . .
   move x - sz / 2 y - sz / 2
   rect sz sz
   if sz > 0.5
      h = sz / 3
      call carp x - sz y - sz h
      call carp x - sz y h
      call carp x - sz y + sz h
      call carp x + sz y - sz h
      call carp x + sz y h
      call carp x + sz y + sz h
      call carp x y - sz h
      call carp x y + sz h
   .
.
background 000
clear
color 633
call carp 50 50 100 / 3
