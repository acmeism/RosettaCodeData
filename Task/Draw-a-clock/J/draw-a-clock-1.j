{{
  require'gl2'
  coinsert 'jgl2'
  clock_face_paint=: {{
    try.
      'H M S'=. _3{.6!:0''
      glclear''
      center=. 2-~<.-:glqwh''
      glpen 2: glrgb 0 0 0 255
      glellipse 1+,0 2*/center
      center {{ gllines <.2+(m,m)+,0.97 1*/m*+.j.y}}"0^j.2r12p1*i.12
      center {{ gllines <.2+(m,m)+,0.92 0.99*/m*+.j.y}}"0^j.2r4p1*i.4
      hand=: center {{
        glpen 2: glbrush glrgb<.4{.255*x,4#1
        gllines<.2+m,m*1++.j.n*^j.1p1+y
        EMPTY
      }}
      1 0 0 (0.8) hand 2r60p1*S
      0 1 0 (0.7) hand 2r60p1*M+60%~S
      0 0 1 (0.4) hand 2r12p1*H+60%~M+60%~S
    catch.
      echo 13!:12''
    end.
    EMPTY
  }}
  clock_timer=: glpaint
  wd {{)n
    pc clock closeok;
    cc face isigraph;
    set face wh 200 200;
    ptimer 100;
    pshow;
}}
}}1
