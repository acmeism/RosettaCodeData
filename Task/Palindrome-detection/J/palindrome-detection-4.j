   foo=: foo,|.foo=:2000$a.
   ts=:6!:2,7!:2  NB. time and space required to execute sentence
   ts 'isPalin0 foo'
2.73778e_5 5184
   ts 'isPalin1 foo'
0.0306667 6.0368e6
   ts 'isPalin2 foo'
0.104391 1.37965e7
   'isPalin1 foo' %&ts 'isPalin0 foo'
1599.09 1164.23
   'isPalin2 foo' %&ts 'isPalin0 foo'
3967.53 2627.04
