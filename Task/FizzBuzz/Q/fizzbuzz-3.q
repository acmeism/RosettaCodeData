q)show x:1+til 20
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
q)x mod/:5 3
1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0
1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2
q)not x mod/:5 3
00001000010000100001b
00100100100100100100b
q)show i:2 sv not x mod/:5 3  / binary decode
0 0 1 0 2 1 0 0 1 2 0 1 0 0 3 0 0 1 0 2
q)(`$string x;`fizz;`buzz;`fizzbuzz)
`1`2`3`4`5`6`7`8`9`10`11`12`13`14`15`16`17`18`19`20
`fizz
`buzz
`fizzbuzz
q)i'[`$string x;`fizz;`buzz;`fizzbuzz]  / Case iterator
`1`2`fizz`4`buzz`fizz`7`8`fizz`buzz`11`fizz`13`14`fizzbuzz`16`17`fizz`19`buzz
