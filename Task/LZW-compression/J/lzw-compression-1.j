encodeLZW =: 4 : 0
 d=. ;/x
 r=.0$0
 wc=.w=.{.y
 for_c. }.y do.
   wc=.w,c
   if. d e.~ <wc do. w=.wc else.
     r=. r, d i.<w
     d=.d,<wc
     w=.c
   end.
 end.
 r, d i.<w
)
