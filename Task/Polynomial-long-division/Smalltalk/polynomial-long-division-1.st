Object subclass: Polynomial [
  |coeffs|
  Polynomial class >> new [ ^ super basicNew init ]
  init [ coeffs := OrderedCollection new. ^ self ]
  Polynomial class >> newWithCoefficients: coefficients [
    |r|
    r := super basicNew.
    ^ r initWithCoefficients: coefficients
  ]
  initWithCoefficients: coefficients [
    coeffs := coefficients asOrderedCollection.
    ^ self
  ]
  / denominator [ |n q|
    n := self deepCopy.
    self >= denominator
      ifTrue: [
        q := Polynomial new.
        [ n >= denominator ]
          whileTrue: [ |piv|
 	    piv := (n coeff: 0) / (denominator coeff: 0).
	    q addCoefficient: piv.
	    n := n - (denominator * piv).
	    n clean
          ].
        ^ { q . (n degree) > 0 ifTrue: [ n ] ifFalse: [ n addCoefficient: 0. n ] }
      ]
      ifFalse: [
        ^ { Polynomial newWithCoefficients: #( 0 ) . self deepCopy }
      ]
  ]
  * constant [ |r| r := self deepCopy.
    1 to: (coeffs size) do: [ :i |
      r at: i put: ((r at: i) * constant)
    ].
    ^ r
  ]
  at: index [ ^ coeffs at: index ]
  at: index put: obj [ ^ coeffs at: index put: obj ]
  >= anotherPoly [
    ^ (self degree) >= (anotherPoly degree)
  ]
  degree [ ^ coeffs size ]
  - anotherPoly [ "This is not a real subtraction between Polynomial: it is an
                   internal method ..."
    |a|
    a := self deepCopy.
    1 to: ( (coeffs size) min: (anotherPoly degree) ) do: [ :i |
      a at: i put: ( (a at: i) - (anotherPoly at: i) )
    ].
    ^ a
  ]
  coeff: index [ ^ coeffs at: (index + 1) ]
  addCoefficient: coeff [ coeffs add: coeff ]
  clean [
    [ (coeffs size) > 0
        ifTrue: [ (coeffs at: 1) = 0 ] ifFalse: [ false ] ]
      whileTrue: [ coeffs removeFirst ].
  ]
  display [
    1 to: (coeffs size) do: [ :i |
      (coeffs at: i) display.
      i < (coeffs size)
        ifTrue: [ ('x^%1 + ' % {(coeffs size) - i} ) display ]
    ]
  ]
  displayNl [ self display. Character nl display ]
].
