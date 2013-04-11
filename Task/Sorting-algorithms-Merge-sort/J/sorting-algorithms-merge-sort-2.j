merge=: 4 : 0
 if. 0= x *@*&# y do. x,y return. end.
 la=.x
 ra=.y
 z=.i.0
 while. la *@*&# ra do.
  if. la  >&{. ra do.
    z=.z,{.ra
    ra=.}.ra
  else.
    z=.z,{.la
    la=.}.la
  end.
 end.
 z,la,ra
)
