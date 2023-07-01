require 'plot'

f=: |: 0 ". 1 2 }. ];._2 noun define
w    a     b     c    d     e  f     prob
f1  0     0     0    0.16   0 0      0.01
f2  0.85 -0.04  0.04 0.85   0 1.60   0.85
f3  0.20  0.23 -0.26 0.22   0 1.60   0.07
f4 -0.15  0.26  0.28 0.24   0 0.44   0.07
)

fm=: {&(|: 2 2 $ f)
fa=: {&(|: 4 5 { f)
prob=: (+/\ 6 { f) I. ?@0:

ifs=: (fa@] + fm@] +/ .* [) prob
getPoints=: ifs^:(<200000)
plotFern=: 'dot;frame 0;grids 0;tics 0;labels 0;aspect 2;color green' plot ;/@|:

   plotFern getPoints 0 0
