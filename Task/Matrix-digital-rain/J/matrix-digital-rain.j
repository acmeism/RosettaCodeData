require'ide/qt/gl2'
coinsert'jgl2'

junk=: 7 u:;48 65 16b30a1(+i.)&.>10 26 90
sz=:40 25
len=: <.1.4*{:sz
heat=: (224 255 255),~(<.0.5+255*(%>./)(-<./)^>:(% >./)i.len)*/0 1 0

cols=: i.0
rows=: i.0
scale=: 24
live=: (#heat)#<i.3 0

update=: {{
  try. glfill 0 0 0 255 catch. wd'timer 0' return. end.
  glfont font=.'courier ',":0.8*scale
  upd=. 0>._3++/?2 2 2 2 4
  cols=: cols,upd{.(?~{.sz)-.(-<.0.3*{:sz){.cols
  rows=: (#cols){.rows
  live=: }.live,<(scale*cols,.rows),.?(#cols)##junk
  for_p. live do.
    gltextcolor glrgb p_index{heat
    if.p_index=<:#live do.
      glfont font,' bold'
    end.
    for_xyj.;p do.
      gltextxy 2{.xyj
      gltext 8 u:junk{~{:xyj
    end.
  end. glpaint''
  keep=: rows<{:sz-1
  cols=: keep#cols
  rows=: keep#rows+1
  EMPTY
}}
sys_timer_z_=: update_base_

wd rplc&('DIMS';":scale*sz) {{)n
  pc rain closeok;
  setp wh DIMS;
  cc green isidraw flush;
  pshow;
  timer 100
}}
