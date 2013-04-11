Object subclass: Sequences [
  Sequences class >> hailstone: n [
      |seq|
      seq := OrderedCollection new.
      seq add: n.
      (n = 1) ifTrue: [ ^seq ].
      (n even) ifTrue: [ seq addAll: (Sequences hailstone: (n / 2)) ]
               ifFalse: [ seq addAll: (Sequences hailstone: ( (3*n) + 1 ) ) ].
      ^seq.
  ]

  Sequences class >> hailstoneCount: n [
      ^ (Sequences hailstoneCount: n num: 1)
  ]

  "this 'version' avoids storing the sequence, it just counts
   its length - no memoization anyway"
  Sequences class >> hailstoneCount: n num: m [
      (n = 1) ifTrue: [ ^m ].
      (n even) ifTrue: [ ^ Sequences hailstoneCount: (n / 2) num: (m + 1) ]
               ifFalse: [ ^ Sequences hailstoneCount: ( (3*n) + 1) num: (m + 1) ].
  ]
].
