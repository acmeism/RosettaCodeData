require 'trig viewmat'
plasma=: 3 :0
  'w h'=. y
  X=. (i. % <:) w
  Y=. (i. % <:) h
  x1=. sin X*16
  y1=. sin Y*32
  xy1=. sin (Y+/X)*16
  xy2=. sin (Y +&.*:/ X)*32
  xy1+xy2+y1+/x1
)
