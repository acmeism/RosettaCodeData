require 'gl2 trig'
coinsert 'jgl2'

DT   =: %30      NB. seconds
ANGLE=: 0.45p1   NB. radians
L    =: 1        NB. metres
G    =: 9.80665  NB. ms_2
VEL  =: 0        NB. ms_1

PEND=: noun define
pc pend;pn "Pendulum";
minwh 320 200; cc isi isigraph flush;
)

pend_run=: verb define
  wd PEND,'pshow'
  wd 'timer ',":DT * 1000
)

pend_close=: verb define
  wd 'timer 0; pclose'
)

sys_timer_z_=: verb define
  recalcAngle_base_ ''
  wd 'psel pend; set isi invalid'
)

pend_isi_paint=: verb define
  drawPendulum ANGLE
)

recalcAngle=: verb define
  accel=. - (G % L) * sin ANGLE
  VEL  =: VEL + accel * DT
  ANGLE=: ANGLE + VEL * DT
)

drawPendulum=: verb define
  width=. {. glqwh''
  ps=. (-: width) , 20
  pe=. ps + 150 <.@* (cos , sin) 0.5p1 + y    NB. adjust orientation
  glclear''
  glbrush glrgb 91 91 91                      NB. gray
  gllines ps , pe
  glellipse (,~ ps - -:) 40 15
  glrect 0 0, width, 20
  glbrush glrgb 255 255 0                     NB. yellow
  glellipse (,~ pe - -:) 15 15                NB. orb
)

pend_run''
