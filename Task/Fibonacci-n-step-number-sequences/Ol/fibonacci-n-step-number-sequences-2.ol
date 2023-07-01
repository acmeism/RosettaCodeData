(print "2, fibonacci : " (ltake (n-fib-iterator '(1 1)) 15))
(print "3, tribonacci: " (ltake (n-fib-iterator '(1 1 2)) 15))
(print "4, tetranacci: " (ltake (n-fib-iterator '(1 1 2 4)) 15))
(print "5, pentanacci: " (ltake (n-fib-iterator '(1 1 2 4 8)) 15))
(print "2, lucas : " (ltake (n-fib-iterator '(2 1)) 15))

; ==>
2, fibonacci : (1 1 2 3 5 8 13 21 34 55 89 144 233 377 610)
3, tribonacci: (1 1 2 4 7 13 24 44 81 149 274 504 927 1705 3136)
4, tetranacci: (1 1 2 4 8 15 29 56 108 208 401 773 1490 2872 5536)
5, pentanacci: (1 1 2 4 8 16 31 61 120 236 464 912 1793 3525 6930)
2, lucas : (2 1 3 4 7 11 18 29 47 76 123 199 322 521 843)
