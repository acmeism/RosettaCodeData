NB. abscissae_of_knots coef ordinates_of_knots
NB. returns the interpolation coefficients for eval
coef =: 4 : 0
 p =. _2 _{.,:y
 for_i. i. # x do.
   p =. (p , ([: }. - }. p {~ _2:) + (x spans~ 2+]) % 2 spans - }. [: {: p"_) i
 end.
 x; , _ 1 {. p
)

NB. unknown_abscissae eval coefficients
eval =: 4 : 0
 'xx p' =. y
 a =. 0
 i =. <: # xx
 while. 0 < i=.<:i do.
   a =. (x-i{xx)%-/(p{~i+2),(i{p),a
 end.
 (p{~>:i)+(x-i{xx)%(p{~i+2)+a
)
