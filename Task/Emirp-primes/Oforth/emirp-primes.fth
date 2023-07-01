: isEmirp(n)
   n isPrime ifFalse: [ false return ]
   n asString reverse asInteger dup n == ifTrue: [ drop false ] else: [ isPrime ] ;

: main(min, max, length)
| l |
   ListBuffer new ->l
   min while(l size length < ) [
      dup max > ifTrue: [ break ]
      dup isEmirp ifTrue: [ dup l add ] 1 +
      ]
   drop l ;
