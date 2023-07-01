Integer method: isPrime
| i |
   self 1 <= ifTrue: [ false return ]
   self 3 <= ifTrue: [ true return ]
   self isEven ifTrue: [ false return ]
   3 self sqrt asInteger for: i [ self i mod ifzero: [ false return ] ]
   true ;
