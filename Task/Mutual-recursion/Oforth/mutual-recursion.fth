Method new: M

Integer method: F
   self 0 == ifTrue: [ 1 return ]
   self self 1 - F M - ;

Integer method: M
   self 0 == ifTrue: [ 0 return ]
   self self 1 - M F - ;

0 20 seqFrom map(#F) println
0 20 seqFrom map(#M) println
