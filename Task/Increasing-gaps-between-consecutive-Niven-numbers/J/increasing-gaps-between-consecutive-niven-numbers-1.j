tasks=: (gap , (,:~ index))@:niven

gap=: 0 ,~ 2 -~/\ ]
index=: i.@:#
niven=: I.@:nivenQ@:i.
nivenQ=: 0 = (|~ ([: (+/"1) 10&#.^:_1))

assert 1 0 1 -: nivenQ 10 11 12   NB. demonstrate correct niven test
assert 1 = +/ 10 12 E. niven 100  NB. the sublist 10 12 occurs once in niven numbers less than 100
assert 0 1 6 90 -: gap 1 2 8 98   NB. show infix swapped subtractions
