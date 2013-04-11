mag =: +/&.:*:"1
norm=: %"1 0 mag
dot =: +/@:*"1

NB. (pos;posr;neg;negr) getvec (x,y)
getvec =: 4 :0 "1
  pt =. y
  'pos posr neg negr' =. x
  if. (dot~ pt-}:pos) > *:posr do.
    0 0 0
  else.
    zb =. ({:pos) (-,+)  posr -&.:*: pt mag@:- }:pos
    if. (dot~ pt-}:neg) > *:negr do.
      (pt,{:zb) - pos
    else.
      zs =. ({:neg) (-,+) negr -&.:*: pt mag@:- }:neg
      if. zs >&{. zb do. (pt,{:zb) - pos
      elseif. zs >&{: zb do. 0 0 0
      elseif. ({.zs) < ({:zb) do. neg - (pt,{.zs)
      elseif. do. (pt,{.zb) - pos end.
    end.
  end.
)


NB. (k;ambient;light) draw_sphere (pos;posr;neg;negr)
draw_sphere =: 4 :0
  'pos posr neg negr' =. y
  'k ambient light' =. x
  vec=. norm y getvec ,"0// (2{.pos) +/ i: 200 j.~ 0.5+posr

  b=. (mag vec) * ambient + k * 0>. light dot vec
)

togray =: 256#. 255 255 255 <.@*"1 0 (%>./@,)

env=.(2; 0.5; (norm _50 30 50))
sph=. 20 20 0; 20;   1 1 _6; 20
'rgb' viewmat togray  env draw_sphere sph
