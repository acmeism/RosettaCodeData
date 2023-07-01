thru=: <./ + -~ i.@+ _1 ^ >        NB. integers from x through y

NB.*getBresenhamLine v Returns points for a line given start and end points
NB. y is: y0 x0 ,: y1 x1
getBresenhamLine=: monad define
  steep=. ([: </ |@-~/) y
  points=. |."1^:steep y
  slope=. %~/ -~/ points
  ypts=. thru/ {."1 points
  xpts=. ({: + 0.5 <.@:+ slope * ypts - {.) {.points
  |."1^:steep ypts,.xpts
)

NB.*drawLines v Draws lines (x) on image (y)
NB. x is: 2-item list (start and end points) ; (color)
drawLines=: (1&{:: ;~ [: ; [: <@getBresenhamLine"2 (0&{::))@[ setPixels ]
