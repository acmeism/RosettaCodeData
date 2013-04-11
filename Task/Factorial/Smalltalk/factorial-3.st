  |fac|

  fac := [:n |
    n < 0 ifTrue: [ self error: 'fac is defined for natural numbers' ].
    n <= 1
        ifTrue: [ 1 ]
        ifFalse: [ n * (fac value:(n - 1)) ]
  ].
  fac value:1000.
].
