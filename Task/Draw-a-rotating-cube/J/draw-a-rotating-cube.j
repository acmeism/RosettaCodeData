require'gl2 gles ide/qt/opengl'
coinsert'jgl2 jgles qtopengl'

rotcube=: {{
  if.0=nc<'sprog'do.return.end.
  fixosx=. 'opengl';'opengl',('DARWIN'-:UNAME)#' version 4.1'
  wd 'pc rot; minwh 300 300; cc cube opengl flush' rplc fixosx
  HD=: ".wd 'qhwndc cube'
  wd 'ptimer 17; pshow'
}}

rot_close=: {{
  wd 'ptimer 0'
  glDeleteBuffers ::0: 2; vbo
  glDeleteProgram ::0: sprog
  erase 'sprog'
  wd 'pclose'
}}

cstr=: {{if.y do.memr y,0 _1 2 else.EMPTY end.}}
gstr=: {{cstr>{.glGetString y}}
diag=: {{p[echo y,': ',p=.gstr".y}}

blitf=: {{
  dat=. 1 fc,y NB. short floats
  glBindBuffer GL_ARRAY_BUFFER; x{vbo
  glBufferData GL_ARRAY_BUFFER; (#dat); (symdat<'dat'); GL_STATIC_DRAW
}}

rot_cube_initialize=: {{
  erase'sprog'
  if.0=#diag 'GL_VERSION' do.echo 'cannot retrieve GL_VERSION' return.end.
  diag each;:'GL_VENDOR GL_RENDERER GL_SHADING_LANGUAGE_VERSION'
  GLSL=:wglGLSL''
  wglPROC''
  'err program'=. gl_makeprogram VSRC ;&fixversion FSRC
  if.#err do. echo 'err: ', err return.end.
  if. GLSL>120 do.vao=: >{:glGenVertexArrays 1;,_1 end.
  assert _1~:vertexAttr=: >{.glGetAttribLocation program;'vertex'
  assert _1~:colorAttr=: >{.glGetAttribLocation program;'color'
  assert _1~:mvpUni=: >{.glGetUniformLocation program;'mvp'
  vbo=: >{:glGenBuffers 2;2#_1
  0 blitf vertexData
  1 blitf colorData
  sprog=: program
}}

VSRC=: {{)n
  #version $version
  $v_in $highp vec3 vertex;
  $v_in $lowp vec3 color;
  $v_out $lowp vec4 v_color;
  uniform mat4 mvp;
  void main(void) {
    gl_Position= mvp * vec4(vertex,1.0);
    v_color= vec4(color,1.0);
  }
}}

FSRC=: {{)n
  #version $version
  $f_in $lowp vec4 v_color;
  $fragColor
  void main(void) {
    $gl_fragColor= v_color;
  }
}}

fixversion=: {{
  NB. cope with host shader language version
  r=.   '$version';GLSL,&":;(GLSL>:300)#(*GLES_VERSION){' core';' es'
  f1=. GLSL<:120
  r=.r, '$v_in';f1{'in';'attribute'
  r=.r, '$v_out';f1{'out';'varying'
  r=.r, '$f_in';f1{'in';'varying'
  r=.r, '$highp ';f1#(*GLES_VERSION)#'highp'
  r=.r, '$lowp ';f1#(*GLES_VERSION)#'lowp'
  f2=.(330<:GLSL)+.(300<:GLSL)**GLES_VERSION
  r=.r, '$gl_fragColor';f2{'gl_FragColor';'fragColor'
  r=.r, '$fragColor';f2#'out vec4 fragColor;'
  y rplc r
}}

rot_timer=: {{
  try.
    gl_sel HD
    gl_paint''
  catch.
     echo 'error in rot_timer',LF,13!:12''
     wd'ptimer 0'
  end.
}}

zeroVAttr=: {{
  glEnableVertexAttribArray y
  glBindBuffer GL_ARRAY_BUFFER; x{vbo
  glVertexAttribPointer y; 3; GL_FLOAT; 0; 0; 0
}}

mp=: +/ .*
ref=: (gl_Translate 0 0 _10) mp glu_LookAt 0 0 1,0 0 0,1 0 0
rot_cube_paint=: {{
  try.
    if.nc<'sprog' do.return.end.
    wh=. gl_qwh''
    glClear GL_COLOR_BUFFER_BIT+GL_DEPTH_BUFFER_BIT [glClearColor 0 0 0 0+%3
    glUseProgram sprog
    glEnable each GL_DEPTH_TEST, GL_CULL_FACE, GL_BLEND
    glBlendFunc GL_SRC_ALPHA; GL_ONE_MINUS_SRC_ALPHA
    mvp=. (gl_Rotate (360|60*6!:1''),1 0 0)mp ref mp gl_Perspective 30, (%/wh),1 20
    glUniformMatrix4fv mvpUni; 1; GL_FALSE; mvp
    if. GLSL>120 do. glBindVertexArray {.vao end.
    0 zeroVAttr vertexAttr
    1 zeroVAttr colorAttr
    glDrawArrays GL_TRIANGLES; 0; 36
    glUseProgram 0
  catch.
    echo 'error in rot_cube_paint',LF,13!:12''
    wd'ptimer 0'
  end.
}}

NB. oriented triangle representation of unit cube
unitCube=:  #:(0 1 2, 2 1 3)&{@".;._2 {{)n
  2 3 0 1 NB. unit cube corner indices
  3 7 1 5 NB. 0: origin
  4 0 5 1 NB. 1, 2, 4: unit distance along each axis
  6 2 4 0 NB. 3, 5, 6, 7:  combinations of axes
  7 6 5 4
  7 3 6 2
}}

NB. orient cube so diagonal is along first axis
daxis=: (_1^5 6 e.~i.3 3)*%:6%~2 0 4,2 3 1,:2 3 1
vertexData=:(_1^unitCube)mp daxis NB. cube with center at origin
colorData=: unitCube NB. corresponding colors

rotcube''
