decodeLZW =: 4 : 0
 d=.;/x
 w=.r=. >d{~{.y
 ds=. #d
 for_c. }.y do.
   select. * c-ds
    case. _1 do. r=.r,e=.>c{d
    case.  0 do. r=.r,e=.w,{.w
    case.    do. 'error' return.
   end.
   d=.d,< w,{.e
   w=.e
   ds=.ds+1
 end.
 ;r
)
