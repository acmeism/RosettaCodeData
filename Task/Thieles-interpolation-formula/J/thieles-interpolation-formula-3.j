thiele =: 2 : 0
 p =. _2 _{.,:n
 for_i. i.#m do.
   p =. (p , ([: }. - }. p {~ _2:) + (m spans~ 2+]) % 2 spans - }. [: {: p"_) i
 end.
 p =. , _ 1 {. p
 a =. 0
 i =. <:#m
 while. 0 < i=.<:i do.
   a =. (y-i{m)%-/(p{~i+2),(i{p),a
 end.
 (p{~>:i)+(y-i{m)%a+p{~i+2
)
