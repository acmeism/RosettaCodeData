Exception Class new: U0
Exception Class new: U1

: baz  ifZero: [ "First call" U0 throw ] else: [ "Second call" U1 throw ] ;
: bar  baz ;

: foo
| e |
   try: e [ 0 bar ] when: [ e isKindOf(U0) ifTrue: [ "Catched" .cr ] else: [ e throw ] ]
   try: e [ 1 bar ] when: [ e isKindOf(U0) ifTrue: [ "Catched" .cr ] else: [ e throw ] ]
   "Done" . ;
