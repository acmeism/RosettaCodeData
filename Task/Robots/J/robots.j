require'~addons/ide/qt/gl2.ijs'
coinsert'jgl2'

move_handler=: {{
  if. 'char'-:systype do.wd'timer 0'
    select.{.tolower sysdata
      case.'y'do.move _1 _1
      case.'k'do.move  0 _1
      case.'u'do.move  1 _1
      case.'h'do.move _1  0
      case.' 'do.move  0  0
      case.'l'do.move  1  0
      case.'b'do.move _1  1
      case.'j'do.move  0  1
      case.'n'do.move  1  1
      case.'w'do.giveup''
      case.'t'do.teleport''
    end.
  end.
}}

Directions=:({.~ i.&'0'){{)n
Directions:

y k u
 \|/
h- -l
 /|\
b j n

Commands:

w: wait for end
t: teleport

Legend:

+: robot
*: junk heap
@: you

Score: 0
}}

query_handler=: {{game_handler=: m&{{if.'char'-:systype do.x`]@.('ny'i.{.sysdata)0 end.}}}}
teleport=: {{move (dim#:?*/dim)-player}}
start=: {{initlevel 1[score=: 0}}
advance=: {{initlevel level+1}}
color=: [ gltextcolor@glrgb@{{<.0.5+255*y}}
at=: (gltext@[ [ gltextxy@])"1
dim=: 110 72
has=: +./ .=

showscore=: {{
  t=. ];._2 LF,~Directions,":y
  t at"_1] 1130,.14*2+i.#t
  botrow=. I. '+' e."1 >t
  '+' at 1130,14*2+botrow color 1 0 0
  '*' at 1130,14*3+botrow color 1 0 1*0.5
  '@' at 1130,14*4+botrow color 0 1 0.75
}}

initlevel=: {{
  game_handler=: move_handler
  junk=:(#~ has&(dim-1) +. has&0)dim#:i.*/dim
  'player bots'=: ({.;}.) 1+(dim-2) #: (1+10*y) ? */dim-2
  drawboard level=: y
}}

drawboard=: {{
  glclear''
  glfont '"courier" 12'
  showscore score   color 0 0 0
  '+' at 10*bots    color 1 0 0
  '*' at 10*junk    color 1 1 0*0.5
  '@' at 10*player  color 0 1 0*0.75
  glpaint''
}}

move=: {{
  player=: player+y
  'hazards crashes'=.(~.;1<#/.~) (2#junk),bots-*bots-"1 player
  junk=: hazards#~crashes
  bots=: hazards#~crashes=0
  score=: level#.5 5,-#bots
  drawboard''
  if.player e.junk,bots do.lose''
  elseif.0=#bots do.win'' end.
}}

lose=: {{
  wd'timer 0'
  glfont '"courier" 96'
  game_handler=: quit`start query_handler
  'Game Over' at 320 320  color 1 0 0
  glfont '"courier" 24'
  'Start over? (y/n)' at 480 480 color 0 0 0
}}

win=: {{
  glfont '"courier" 96'
  game_handler=: quit`advance query_handler
  'You Win' at 320 320  color 0 1 0
  glfont '"courier" 24'
  'Continue? (y/n)' at 480 480 color 0 0 0
}}

giveup=: {{
  sys_timer_z_=: {{move_base_ 0 0}}
  wd'timer 100'
}}

wd'pc game closeok; setp wh 1280 720; cc chase isidraw flush;pshow'
start''
