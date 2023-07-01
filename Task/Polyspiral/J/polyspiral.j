require 'gl2 trig media/imagekit'
coinsert 'jgl2'

DT       =: %30       NB. seconds
ANGLE    =: 0.025p1   NB. radians
DIRECTION=: 0         NB. radians

POLY=: noun define
  pc poly;pn "Poly Spiral";
  minwh 320 320; cc isi isigraph;
)

poly_run=: verb define
  wd POLY,'pshow'
  wd 'timer ',":DT * 1000
)

poly_close=: verb define
  wd 'timer 0; pclose'
)

sys_timer_z_=: verb define
  recalcAngle_base_ ''
  wd 'psel poly; set isi invalid'
)

poly_isi_paint=: verb define
  drawPolyspiral DIRECTION
)

recalcAngle=: verb define
  DIRECTION=: 2p1 | DIRECTION + ANGLE
)

drawPolyspiral=: verb define
  glclear''
  x1y1 =. (glqwh'')%2
  a=. -DIRECTION
  len=. 5
  for_i. i.150 do.
    glpen glrgb Hue a % 2p1
    x2y2=. x1y1 + len*(cos,sin) a
    gllines <.x1y1,x2y2
    x1y1=. x2y2
    len=. len+3
    a=. 2p1 | a - DIRECTION
  end.
)

poly_run''
