g  =: 1
I  =:     0&{"1
M  =:     1&{"1
IM =:   0 1&{"1
D  =: 3 : 0"1
   2 3 4{y
:
   2 3 4{y-x
)
V  =: 5 6 7&{"1
D3 =: 4 : '(%:+/*:x D y)^3'"1
F  =: 3 : 0"1
   y F/y
:
   g*(M x)*(M y)*(y D x) % (x D3 y)
)
A  =: 3 : 0
   ff =. y F/y
   f =. +/ff
   f % (M y)
)
NEXT =: 4 : 0
   dt =. x
   im =. IM y
   p0  =. D y
   v0  =. V y
   f =.  +/(F/~y)
   a =. f%M y
   v1  =. v0 + dt * a
   p1  =. p0 + dt * (v0 + v1)%2
   z =. |: ((|: im),(|: p1),(|: v1))
   out =: out,D z
   z
)
