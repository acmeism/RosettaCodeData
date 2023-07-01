hc=: 4 : 0
 if. 1=#x do. y
 else. ((i{x),+/j{x) hc (i{y),<j{y [ i=. (i.#x) -. j=. 2{./:x end.
)

hcodes=: 4 : 0
 assert. x -:&$ y           NB. weights and words have same shape
 assert. (0<:x) *. 1=#$x    NB. weights are non-negative
 assert. 1 >: L.y           NB. words are boxed not more than once
 w=. ,&.> y                 NB. standardized words
 assert. w -: ~.w           NB. words are unique
 t=. 0 {:: x hc w           NB. minimal weight binary tree
 ((< S: 0 t) i. w) { <@(1&=)@; S: 1 {:: t
)
