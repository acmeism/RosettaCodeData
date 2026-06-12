require'ide/qt/gl2'
coinsert'jgl2'

NB. event handlers
game_reset_button=: {{ draw COUNT=: #SETUP=: EMPTY [BOARD=: WIN }}
game_restart_button=: {{ draw COUNT=: 0 [rotate"1 SETUP [BOARD=: WIN }}
game_easy_button=: {{ setup 3 }}
game_hard_button=: {{ setup 15 }}
game_board_mbldown=: {{
  loc=. (20+40*i.5)I.2{._".sysdata
  if. 1=#ndx=. loc -. 0 5 do.
    side=. 2#.<:>.loc%4 NB. _2: left, _1 top, 1 bottom, 2 right
    draw rotate side, ndx
  end.
}}

NB. game logic
BOARD=: WIN=: 1+i.4 4
message=: {{
  color=. (COUNT>#SETUP){::;:'black red'
  A=. '<span style="color: ',color,'">' [Z=. '</span>'
  if. BOARD-:WIN do. A,'You win',Z return. end.
  A,(":COUNT),Z,' of ',":#SETUP
}}
setup=: {{ game_restart_button SETUP=: (_2 _1 1 2{~?y#4),.1+?y#4 }}
rotate=: {{
  COUNT=: COUNT+1
  'side ndx'=. y-0 1
  flip=. |: if. 2=|side do. flip=. ] end.
  BOARD=: flip ((*side)|.ndx{flip BOARD) ndx} flip BOARD
}}

NB. rendering
wd {{)n
  pc game closeok;
  cc board isidraw;
  set board wh 200 200;
  cc msg static center;
  bin h;
    cc easy button;
    set easy tooltip start game which can be completed in 3 moves;
    cc hard button;
    set hard tooltip start game which can be completed in 15 moves;
  bin z; bin h;
    cc restart button;
    cc reset button;
    set reset tooltip set board to initial position, ending any current game;
  pshow;
}}

draw=: {{
  glclear''
  glbrush glrgb 3#224     NB. silver
  glrect 0 0 200 200
  glbrush glrgb 0 0 255   NB. blue
  glrect T=:20 20 40 40+"1]40*4 4 1 1#:i.4 4
  glbrush glrgb 255 255 0 NB. yellow
  glpolygon (,200-])(,;"1@(_2<@|.\"1]))0 30 0 50 10 40+"1(i.4)*/6$0 40
  gltextcolor glrgb 3#255 NB. white
  glfont '"lucidia console" 16'
  BOARD {{ gltext ":x [ gltextxy y+5 0*_1^1<#":x }}"_2(30+40*4 4#:|:i.4 4)
  if. EMPTY-:SETUP do.
    wd {{)n
     set msg text <b>easy</b> or <b>hard</b> to start;
     set restart enable 0;
     set restart caption;
}} else. wd {{)n
    set msg text MESSAGE;
    set restart enable 1;
    set restart caption restart;
}} rplc 'MESSAGE';message''
  end.
  glpaint''
}}

NB. start:
game_reset_button''
