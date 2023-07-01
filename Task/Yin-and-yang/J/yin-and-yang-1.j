yinyang=:3 :0
  radii=. y*1 3 6
  ranges=. i:each radii
  squares=. ,"0/~each ranges
  circles=. radii ([ >: +/"1&.:*:@])each squares
  cInds=. ({:radii) +each circles #&(,/)each squares

  M=. ' *.' {~  circles (*  1 + 0 >: {:"1)&(_1&{::) squares
  offset=. 3*y,0
  M=. '*' ((_2 {:: cInds) <@:+"1 offset)} M
  M=. '.' ((_2 {:: cInds) <@:-"1 offset)} M
  M=. '.' ((_3 {:: cInds) <@:+"1 offset)} M
  M=. '*' ((_3 {:: cInds) <@:-"1 offset)} M
)
