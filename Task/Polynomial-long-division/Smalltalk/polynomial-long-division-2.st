|res|
res := OrderedCollection new.

res add:  ((Polynomial newWithCoefficients: #( 1 -12 0 -42) ) /
           (Polynomial newWithCoefficients: #( 1 -3 ) )) ;
    add:  ((Polynomial newWithCoefficients: #( 1 -12 0 -42) ) /
           (Polynomial newWithCoefficients: #( 1 1 -3 ) )).

res do: [ :o |
  (o at: 1) display. ' with rest: ' display. (o at: 2) displayNl
]
