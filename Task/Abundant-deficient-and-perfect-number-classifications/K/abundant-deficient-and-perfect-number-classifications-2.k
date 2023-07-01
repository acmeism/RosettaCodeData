/Classification of numbers into abundant, perfect and deficient
/ numclass.k

/return 0,1 or -1 if perfect or abundant or deficient respectively
 numclass: {s:(+/&~(!1+x)!\:x)-x; $[s>x;:1;$[s<x;:-1;:0]]}
/classify numbers from 1 to 20000 into respective groups
 c: =numclass' 1+!20000
/print statistics
 `0: ,"Deficient = ", $(#c[-1])
 `0: ,"Perfect   = ", $(#c[0])
 `0: ,"Abundant  = ", $(#c[1])
