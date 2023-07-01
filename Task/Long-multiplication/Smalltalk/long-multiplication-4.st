Integer
    subclass: #RosettaInteger
    instanceVariableNames:'digitArray'
    classVariableNames:'WORDMAX'
    package:'Rosetta demos'
!

!RosettaInteger class methodsFor:'initialization'!

initialize
    WORDMAX := 100.
! !

!RosettaInteger class methodsFor:'instance creation'!

newWithDigits:digitArray
    "returns a new RosettaInteger with a digitArray"

    ^ self basicNew digits:digitArray
!

fromInteger:anInteger
    "returns a new RosettaInteger with anInteger's value"

    |digits gen|

    gen := [:n :s |
            s nextPut:(n % 100).
            n > 99 ifTrue:[ gen value:(n // 100) value:s]].
    digits := Array streamContents:[:s | gen value:anInteger value:s].
    ^ self newWithDigits:digits
! !

!RosettaInteger class methodsFor:'helpers'!

addDigits:a and:b
    |add|

    add :=
        [:a :b |
            Array streamContents:[:s |
                |cy|
                cy := 0.
                1 to:(a size max:b size) do:[:wordIndex |
                    |sum|
                    wA := a at:wordIndex ifAbsent:0.
                    wB := b at:wordIndex ifAbsent:0.
                    sum := (wA + wB + cy).
                    cy := (sum // WORDMAX).
                    s nextPut:(sum % WORDMAX).
                ].
                cy ~~ 0 ifTrue:[s nextPut:cy].
            ].
        ].
    ^ add value:a value:b
!

mulDigits:a and:b
    |mulW|

    mulW :=
        [:a :w |
            |cy|
            cy := 0.
            Array streamContents:[:s |
                a do:[:wordA |
                    |product|
                    product := (wordA * w) + cy.
                    s nextPut:(product % WORDMAX).
                    cy := (product // WORDMAX)
                ].
                cy ~~ 0 ifTrue:[s nextPut:cy].
            ]
        ].

    mul :=
        [:a :b |
            |sum|

            sum := #( 0 ).
            b doWithIndex:[:wordB :wordIndex |
                partSum := mulW value:a value:wordB.
                shifted := (Array new:wordIndex-1 withAll:0),partSum.
                sum := self addDigits:sum and:shifted.
            ].
            sum.
        ].

    ^ mul value:a value:b.
! !

!RosettaInteger methodsFor:'private accessing'!
digits
    "return my digitArray"

    ^ digitArray
!

digits:digits
    "set my digitArray"

    digitArray := digits
! !

!RosettaInteger methodsFor:'arithmetic'!
+ aNumber
    ^ aNumber sumFromRosettaInteger:self
!

* aNumber
    ^ aNumber productFromRosettaInteger:self
!

raisedTo:exp
    |raise|

    raise :=
        [:a :exp |
            |e rslt|

            rslt := #(1).
            t := a.
            e := exp.
            [e ~~ 0] whileTrue:[
                [(e bitAnd:1) == 0] whileTrue:[
                    e := e bitShift:-1.
                    t := self class mulDigits:t and:t.
                ].
                e := e - 1.
                rslt := self class mulDigits:rslt and:t.
            ].
            rslt.
        ].
   ^ self class newWithDigits:(raise value:(self digits) value:exp)
!

sumFromRosettaInteger:anRInt
   ^ self class
        newWithDigits:(self class addDigits:(anRInt digits) and:(self digits))
!

productFromRosettaInteger:anRInt
   ^ self class newWithDigits:(self class mulDigits:(anRInt digits) and:(self digits))
! !

!RosettaInteger methodsFor:'printing'!

printOn:aStream
    |print|

    print :=
        [:n :stream |
            |first|
            first := true.
            n reverseDo:[:_2Digits |
                first
                    ifTrue:[ stream nextPutAll:(_2Digits printString)]
                    ifFalse:[ stream nextPutAll:(_2Digits printString leftPaddedTo:2 with:$0)].
                first := false.
            ].
        ].

    print value:(self digits) value:aStream
! !

!Integer methodsFor:'converting'!

asRosettaInteger
    ^ RosettaInteger fromInteger:self
! !

!Integer methodsFor:'double dispatching'!

sumFromRosettaInteger:anRInt
    ^ anRInt + (RosettaInteger fromInteger:self)
!

productFromRosettaInteger:anRInt
    ^ anRInt * (RosettaInteger fromInteger:self)
! !

RosettaInteger initialize
!

a := 124 asRosettaInteger.
e'a is: {a} ({a class})' printCR.
b := 333 asRosettaInteger.
e'b is: {b} ({b class})'printCR.
a_plus_b := a+b.
e'(a+b) is: {a_plus_b} ({(a_plus_b) class})' printCR.

c := 999 asRosettaInteger.
e'c is: {c} ({c class})' printCR.
c_plus_1 := c+1.
e'c+1 is: {c_plus_1} ({(c_plus_1) class})' printCR.

d := 100 asRosettaInteger.
e'd is: {d} ({d class})' printCR.
d_squared := d squared.
e'd squared is: {d_squared} ({d_squared class})' printCR.

e := 2 asRosettaInteger.
e_raisedTo_64 := e raisedTo:64.
e'2 raisedTo:64 is: {e_raisedTo_64} ({e_raisedTo_64 class})' printCR.

e_raisedTo_64_squared := (e raisedTo:64) squared.
e'result is: {e_raisedTo_64_squared} ({e_raisedTo_64_squared class})' printCR.

Transcript show:'once again: '.
result := (2 asRosettaInteger raisedTo:64) squared.
Transcript showCR:result.
