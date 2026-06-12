require'ide/qt/gl2'
coinsert'jgl2'

NB. event handlers
game_board_mbldown=: {{
  xy=.<.40%~2{._ ".sysdata
  if. xy e. EDGES do.
    probe xy
  elseif. xy e. BLACK do.
    guess xy
  end.
  draw''
}}

game_finish_button=: {{ draw FINISHED=: 1 [BEAM=: EMPTY }}

NB. support code
crds=: 2 {."1 ]
dirs=:_2 {."1 ]

probe=: {{
  BEAM=: ,:y
  dir=. DIRS{~EDGES i.y
  while. -. ({:BEAM) e. ATOMS do.
    bar=. (#~ 1-0 e.,@dirs)MIRRORS#~(crds MIRRORS) e. _1{.BEAM
    if. 1=#bar do. dir=.{.(/: |@j./"1) dir(+,:-),dirs bar
    elseif. 2=#bar do. dir=. -dir
    end.
    BEAM=: BEAM,dir+{:BEAM
    if. -.({:BEAM) e. BLACK do. break. end.
  end.
  if. 1 e. BEAM e. BLACK do.
    select. #e=.BEAM([-.-.)EDGES
      case. 1 do. BEAM remember 'H'
      case. 2 do. BEAM remember (#~.e){::'?';'R';0
    end.
  else.
    (BEAM=:1{.BEAM) remember 'R'
  end.
}}
remember=: {{
  ndx=. EDGES i.x([-.-.)EDGES
  if. 0=y do. y=. ":{.(0-.~~.0,,0".&>ndx{LABELS),1+>./0,,0".&>LABELS end.
  LABELS=: (<y) ndx} LABELS
}}

guess=: {{ if.-.FINISHED do. GUESSES=: GUESSES ,`-.@.(e.~) y end. }}

NB. rendering
bbox=: {{
  4 bbox y
:
wd{{)n
  pc game closeok;
  cc message static center;
  cc board isidraw;
  set board wh SZ SZ;
  cc finish button;
  pshow;
}} rplc 'SZ';":40*2+SIZE=:y
  BLACK=: ,/1+DIM#:i.DIM=:,~SIZE
  EDGES=: (,/(2+DIM)#:i.2+DIM)-.BLACK,>,{;~0 1*DIM+1
  DIRS=: (1+SIZE) ((*@| |."1) * _1^=) EDGES
  LABELS=: (#EDGES)#a:
  ATOMS=: ({~ x?#) BLACK
  MIRRORS=: /:~,/ATOMS(+,])"1/0 0-.~>,{;~i:1
  GUESSES=: EMPTY
  BEAM=: EMPTY
  FINISHED=: 0
  draw''
}}

boxes=: {{ 40*4{.!.1"1 y }}
drawatoms=: {{ glellipse 5 5 _10 _10+"1]boxes y[glpen glbrush glrgb x }}

draw=: {{
  glclear''
  glfont '"Lucidia Console" 15' [gltextcolor glrgb 0 255 255 NB. yellow
  glpen 2 1[glrgb 3#255 NB. white
  glrect boxes EDGES [glbrush glrgb 184 0 0 NB. dark red
  glrect boxes BLACK [glbrush glrgb 0 0 0
  wd 'set message text ',N,&":' point','s'#~1~:N=.(FINISHED*5*#GUESSES-.ATOMS)++/LABELS~:a:
  if. FINISHED do.
    255 0 0 drawatoms GUESSES -. ATOMS
    0 255 0 drawatoms ATOMS([-.-.)GUESSES
    0 0 255 drawatoms ATOMS-.GUESSES
    if.#BEAM do.
      gllines 20+,40*BEAM [glpen 2 1 [glbrush glrgb 255 255 0
      glellipse 15 15 10 10+4{.40*{.BEAM
    end.
  else.
    128 128 128 drawatoms GUESSES
  end.
  (10+40*EDGES) {{ gltext;y [ gltextxy x }}"_1 LABELS
  wd 'set finish enable ',":FINISHED<GUESSES=&#ATOMS
  glpaint''
}}
