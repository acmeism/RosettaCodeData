require'trig'
GEN =: 3 : 0
   1 GEN y
:
   m =. 1
   r =. 1
   p =. r*(|:(2,y)$(cos,sin)(i.y)*2*pi%y),.0
   v =. x*(|:(2,y)$(cos,sin)(pi%2)+(i.y)*2*pi%y),.0
   (i.y),.(y#m),.p,.v
)
