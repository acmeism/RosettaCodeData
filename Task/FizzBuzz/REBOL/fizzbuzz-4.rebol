m: func [i d] [0 = mod i d]
spick: func [t x y][either any [not t  "" = t][y][x]]
zz: func [i] [rejoin [spick m i 3 "Fizz" ""  spick m i 5 "Buzz" ""]]
repeat i 100 [print spick z: zz i z i]
