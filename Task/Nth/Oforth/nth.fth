: nth(n)
| r |
   n "th" over 10 mod ->r
   r 1 == ifTrue: [ n 100 mod 11 == ifFalse: [ drop "st" ] ]
   r 2 == ifTrue: [ n 100 mod 12 == ifFalse: [ drop "nd" ] ]
   r 3 == ifTrue: [ n 100 mod 13 == ifFalse: [ drop "rd" ] ]
   + ;
