"/ mhmh hard to avoid largeInteger arithmetic,
"/ as the language does not specify, how many bits are used to represent
"/ SmallIntegers, and when the VM uses LargeInts.
"/ Lets assume, we run on a 2-digit decimal machine (smile).
"/ So lets work hard to avoid any convenient VM support,
"/ by doing decimal arithmetic (running on a decimal machine from the 1940s)
"/ and only allow 0..99 in a word (assuming it has a 2*2->4 digit multiply available)
"/ (smile: remember the Knuth MIX machine?)
"/ Long integers are represented as an array of such 2-digit words (least significant first).

"/ the code below should never ever been taken serious
"/ Not even as didactic example.
"/ NOONE WOULD EVER DO SUCH A STUPID THING

WORDMAX := 100.
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

"/ test 12,34 + 1
a := #( 34 12 ).
b := #( 1 ).
self assert:( add value:a value:b ) = #( 35 12 ).

"/ test 99,99 + 1
a := #( 99 99 ).
b := #( 1  ).
self assert:( add value:a value:b ) = #( 00 00 1 ).

"/ test 99,99,99,99 + 99,99,99,99
a := #( 99 99 99 99 ).
b := #( 99 99 99 99 ).
self assert:( add value:a value:b ) = #( 98 99 99 99 1).

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

"/ test 1 * 2
a := #( 1 ).
self assert:( mulW value:a value:2) = #( 2).

"/ test 2 * 99
a := #( 2 ).
self assert:( mulW value:a value:99) = #( 98 1).

"/ test 99,99,99,99 * 99
a := #( 99 99 99 99 ).
self assert:( mulW value:a value:99) = #( 01 99 99 99 98 ).

mul :=
    [:a :b |
        |sum|

        sum := #( 0 ).
        b doWithIndex:[:wordB :wordIndex |
            partSum := mulW value:a value:wordB.
            shifted := (Array new:wordIndex-1 withAll:0),partSum.
            sum := add value:sum value:shifted.
        ].
        sum.
    ].

"/ test 99,99,99,99 * 99
a := #( 99 99 99 99 ).
b := #( 99  ).
self assert:( mul value:a value:b) = #( 01 99 99 99 98 ).

raise :=
    [:a :exp |
        |e rslt|

        rslt := #(1).
        t := a.
        e := exp.
        [e ~~ 0] whileTrue:[
            [(e bitAnd:1) == 0] whileTrue:[
                e := e bitShift:-1.
                t := mul value:t value:t.
            ].
            e := e - 1.
            rslt := mul value:rslt value:t.
        ].
        rslt.
    ].

"/ test 2 ** 64
a := #( 2  ).
self assert:( raise value:a value:64) = #( 16 16 55 09 37 07 44 67 44 18).

"/ test (2 ** 64) * (2 ** 64)
a := #( 2  ).
t := raise value:a value:64.
rslt := mul value:t value:t.
self assert:rslt = #( 56 14 21 68 17 43 07 46 37 63 34 46 38 09 92 66 23 28 40 3).

"/ the biggest plus of having a decimal machine is that it makes printing so easy...
printOn :=
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

printOn value:rslt value:Transcript.

"/ verify...
printedString := String streamContents:[:s | printOn value:rslt value:s].
self assert:(printedString = (2**64) squared printString)
