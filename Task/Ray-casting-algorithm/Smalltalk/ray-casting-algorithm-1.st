Object subclass: Segment [
    |pts|
    Segment class >> new: points [ |a|
      a := super new.
      ^ a init: points
    ]
    init: points [ pts := points copy. ^self ]
    endPoints [ ^pts ]
    "utility methods"
    first [ ^ pts at: 1]
    second [ ^ pts at: 2]
    leftmostEndPoint [
      ^ (self first x > self second x) ifTrue: [ self second ] ifFalse: [ self first ]
    ]
    rightmostEndPoint [
      ^ (self first x > self second x) ifTrue: [ self first ] ifFalse: [ self second ]
    ]
    topmostEndPoint [
      ^ (self first y > self second y) ifTrue: [ self first ] ifFalse: [ self second ]
    ]
    bottommostEndPoint [
      ^ (self first y > self second y) ifTrue: [ self second ] ifFalse: [ self first ]
    ]

    slope [
      (pts at: 1) x ~= (pts at: 2) x
      ifTrue: [ ^ ((pts at: 1) y - (pts at: 2) y) / ((pts at: 1) x - (pts at: 2) x) ]
      ifFalse: [ ^ FloatD infinity ]
    ]

    doesIntersectRayFrom: point [ |p A B|
      (point y = (pts at: 1) y) | (point y = (pts at: 2) y)
      ifTrue: [ p := Point x: (point x) y: (point y) + 0.00001 ]
      ifFalse: [ p := point copy ].
      A := self bottommostEndPoint.
      B := self topmostEndPoint.
      (p y < A y) | (p y > B y) | (p x > (self rightmostEndPoint x))
        ifTrue: [ ^false ]
        ifFalse: [ (p x < (self leftmostEndPoint x))
                     ifTrue: [ ^true ]
                     ifFalse: [ |s|
                        s := Segment new: { A . point }.
			(s slope) >= (self slope)
			  ifTrue: [ ^ true ]
                     ]
                 ].
        ^false
    ]
].

Object subclass: Polygon [
    |polysegs|
    Polygon class >> new [ |a| a := super new. ^ a init. ]
    Polygon class >> fromSegments: segments [ |a|
      a := super new.
      ^ a initWithSegments: segments
    ]
    Polygon class >> fromPoints: pts and: indexes [ |a|
      a := self new.
      indexes do: [ :i |
        a addSegment: ( Segment new: { pts at: (i at: 1) . pts at: (i at: 2) } )
      ].
      ^ a
    ]
    initWithSegments: segments [
      polysegs := segments copy. ^self
    ]
    init [ polysegs := OrderedCollection new. ^ self ]
    addSegment: segment [ polysegs add: segment ]

    pointInside: point [ |cnt|
      cnt := 0.
      polysegs do: [ :s | (s doesIntersectRayFrom: point)
                          ifTrue: [ cnt := cnt + 1 ] ].
      ^ ( cnt \\ 2 = 0 ) not
    ]
].
