| fac |
fac := [ :n | (1 to: n) inject: 1 into: [ :prod :next | prod * next ] ].
fac value: 10.
"3628800"
