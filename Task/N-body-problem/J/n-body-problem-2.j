dt =: 0.001
maxn =: 20000
require'plot'
ITER =: 3 : 0
   maxn ITER y
:
   out =: (0,(#y),3)$0
   dt NEXT^:x y
   plot 0 1 { |: out
)
