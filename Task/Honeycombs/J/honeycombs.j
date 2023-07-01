require'ide/qt/gl2'
coinsert'jgl2'

NB. corners of a unit hexagon
ucorn=: +.^j.2p1*(%~i.)6

NB. center to center offset for columns and rows
uof=: %:2.3 3

shape=: 4 5
scale=: 50
scorn=: scale*ucorn
centers=: scale*(((%:0 0.75)*/~2|{:"1)+uof*"1 1:+|."1)shape#:i.shape

honeycomb=: {{)n
  pc honeycomb nosize closeok;
  minwh 460 460;
  cc hex isidraw flush;
  pshow;
}}{{
  sel=: 0"0 grid=: shape$u:65+(*/shape)?26
  txt=:''
  wd m
  draw y
}}

draw=: {{
  glfill 0 0 0 255
  hex"0 i.$grid
  gltextcolor glrgb 0 0 255
  glfont 'courier 24'
  gltextxy 60 10
  glpaint gltext txt
}}

hex=: {{
  coord=. <shape#:y
  center=. coord{centers
  glbrush glrgb (-coord{sel)|.255 255 0
  glrgb 255 255 255
  glpen 3,PS_SOLID
  glpolygon,<.center+"1 scorn
  gltextcolor glrgb 255 0 0
  glfont 'courier 24 bold'
  gltextxy <.center-10
  gltext coord{grid
}}

select_character=: {{
  if. -. y{,sel do. NB. the selected character has been determined
    txt=:txt, y{,grid
  end.
  draw sel=: 1 (y"_)} sel
}}

honeycomb_hex_char=: {{
  ch=. toupper {.sysdata
  if. ch e. ,grid do. select_character (,grid)i.ch end.
}}

honeycomb_hex_mbldown=:{{
  xy=. 2{.".sysdata
  k=. (i.<./)dist=.,+/&.:*:"1 centers-"1 xy
  if. scale > k{dist do.select_character k end.
}}

honeycomb''
