serialize=: ('<?xml version="1.0" ?>',LF),;@serialize1&''
serialize1=:4 :0
  if.L.x do.
    start=. y,'<',(0{::x),'>',LF
    middle=. ;;(}.x) serialize1&.> <'    ',y
    end=. y,'</',(0{::x),'>',LF
    <start,middle,end
  else.
    <y,x,LF
  end.
)
