require 'math/misc/amoeba'

NB.*apollonius v solves Apollonius problems
NB. y is Cx0 Cy0 R0,  Cx1 Cy1 R1,:  Cx2 Cy2 R2
NB. x are radius scale factors to control which circles are included
NB.   in the common tangent circle.  1 to surround, _1 to exclude.
NB. returns Cxs Cys Rs
apollonius =: verb define"1 _
 1 apollonius y
:
 centers=. 2{."1 y
 radii=. x * {:"1 y
 goal=. 1e_20                               NB. goal simplex volume
 dist=. radii + [: +/"1&.:*: centers -"1 ]  NB. distances to tangents
 'soln err'=. ([: +/@:*:@, -/~@dist) f. amoeba goal centers
 if. err > 10 * goal do. '' return. end.    NB. no solution found
 avg=. +/ % #
 (, avg@dist) soln
)
