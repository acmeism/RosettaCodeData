require'ide/qt/gl2'
coinsert 'jgl2'

open=: wd@{{)n
  pc s closeok;
  cc n isidraw;
  set n wh 400 400;
  pshow;
}}

start=: {{
  speed=: {.y,200
  open''
  snake=: 10 10,10 11,:10 12
  newdot''
  draw''
}}

newdot=: {{
  dot=: ({~ ?@#) snake -.~ ,/(#: i.)40 40
}}

s_n_char=: {{
  select. {.toupper sysdata
   case. 'W' do. move  0 _1
   case. 'A' do. move _1  0
   case. 'S' do. move  0  1
   case. 'D' do. move  1  0
  end.
}}

move=: {{
  s_timer=: move@y
  wd 'ptimer ',":speed
  head=. y+{.snake
  if. head e. snake do. head gameover'' return. end.
  if. _1 e. head do. (0>.head) gameover'' return. end.
  if. 1 e. 40 <: head do. (39<.head) gameover'' return. end.
  if. dot -: head do.
    snake=: dot,snake
    newdot''
  else.
    snake=: head,}: snake
  end.
  draw''
}}

draw=: {{
  glclear''
  glbrush glrgb 0 0 255
  glrect 10*}.snake,"1(1 1)
  glbrush glrgb 0 255 0
  glrect 10*({.snake),1 1
  glbrush glrgb 255 0 0
  glrect 10*dot,1 1
  glpaint''
  EMPTY
}}

gameover=: {{
  wd 'ptimer 0'
  if. 1<#snake do.
    echo 'game over'
    echo 'score: ',":(#snake)*1000%speed
    draw''
    glbrush glrgb 255 255 0
    glrect 10*x,1 1
  end.
  snake=: ,:_ _
}}
