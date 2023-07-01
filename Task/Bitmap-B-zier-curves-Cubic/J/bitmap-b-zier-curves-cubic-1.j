require 'numeric'

bik=: 2 : '((*&(u!v))@(^&u * ^&(v-u)@-.))'
basiscoeffs=: <: 4 : 'x bik y t. i.>:y'"0~ i.
linearcomb=: basiscoeffs@#@[
evalBernstein=: ([ +/ .* linearcomb) p. ]        NB. evaluate Bernstein Polynomial (general)

NB.*getBezierPoints v Returns points for bezier curve given control points (y)
NB. eg: getBezierPoints controlpoints
NB. y is: y0 x0, y1 x1, y2 x2 ...
getBezierPoints=: monad define
  ctrlpts=. (/: {:"1)  _2]\ y  NB. sort ctrlpts for increasing x
  xvals=. ({: ,~ {. + +:@:i.@<.@-:@-~/) ({:"1) 0 _1{ctrlpts
  tvals=.  ((] - {.) % ({: - {.)) xvals
  xvals ,.~ ({."1 ctrlpts) evalBernstein tvals
)

NB.*drawBezier v Draws bezier curve defined by (x) on image (y)
NB. eg: (42 40 10 30 186 269 26 187;255 0 0) drawBezier myimg
NB. x is: 2-item list of boxed (controlpoints) ; (color)
drawBezier=: (1&{:: ;~ 2 ]\ [: roundint@getBezierPoints"1 (0&{::))@[ drawLines ]
