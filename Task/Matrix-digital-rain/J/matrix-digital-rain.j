require'gl2'
coinsert'jgl2'

junk=: 7 u:;48 65 16b30a1(+i.)&.>10 26 90
sz=:40 25
len=: <.1.4*{:sz
heat=: (224 255 255),~(<.0.5+255*(%>./)(-<./)^>:(% >./)i.len)*/0 1 0

cols=: i.0
rows=: i.0
scale=: 24
live=: (#heat)#<i.0 3

rain_timer=: {{
  try.
    wd 'psel rain'
    glsel 'green'
    glfill 0 0 0 255
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
    end.
    glpaintx''
    keep=: rows<{:sz-1
    cols=: keep#cols
    rows=: keep#rows+1
    EMPTY
  catch.
    wd'ptimer 0'
  end.
}}

wd rplc&('DIMS';":scale*sz) {{)n
  pc rain closeok;
  setp wh DIMS;
  cc green isidraw flush;
  pshow;
  ptimer 100
}}
