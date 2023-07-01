e := '[ :x :y | (x*x + (y*y)) sqrt ]'.
Transcript show: ((Compiler evaluate: e) value: 3 value: 4).
