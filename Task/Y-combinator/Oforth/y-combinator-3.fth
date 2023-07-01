: almost-fact(n, f)   n ifZero: [ 1 ] else: [ n n 1 - f perform * ] ;
#almost-fact Y => fact

: almost-fib(n, f)   n 1 <= ifTrue: [ n ] else: [ n 1 - f perform n 2 - f perform + ] ;
#almost-fib Y => fib

: almost-Ackermann(m, n, f)
   m 0 == ifTrue: [ n 1 + return ]
   n 0 == ifTrue: [ 1 m 1 - f perform return ]
   n 1 - m f perform m 1 - f perform ;
#almost-Ackermann Y => Ackermann
