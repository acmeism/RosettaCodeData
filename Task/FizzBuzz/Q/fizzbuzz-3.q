q)show x:1+til 20
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
q)x mod\:15 5 3
1  1 1
2  2 2
3  3 0
4  4 1
5  0 2
6  1 0
..
q)(x mod\:15 5 3)?'0
3 3 2 3 1 2 3 3 2 1 3 2 3 3 0 3 3 2 3 1
q)`fizzbuzz`buzz`fizz`(x mod\:15 5 3)?'0  / substitutions
```fizz``buzz`fizz```fizz`buzz``fizz```fizzbuzz```fizz``buzz
q)`$string x  / numbers => symbols
`1`2`3`4`5`6`7`8`9`10`11`12`13`14`15`16`17`18`19`20
q)(`$string x)^`fizzbuzz`buzz`fizz`(x mod\:15 5 3)?'0  / replace nulls with numbers
`1`2`fizz`4`buzz`fizz`7`8`fizz`buzz`11`fizz`13`14`fizzbuzz`16`17`fizz`19`buzz
