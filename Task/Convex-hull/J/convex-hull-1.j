counterclockwise =: ({. , }. /: 12 o. }. - {.) @ /:~
crossproduct =: 11 o. [: (* +)/ }. - {.
removeinner =: #~ (1 , (0 > 3 crossproduct\ ]) , 1:)
hull =: [: removeinner^:_ counterclockwise
