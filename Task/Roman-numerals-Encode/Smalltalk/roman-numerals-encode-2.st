printRomanOn:aStream naive:naive
    "print the receiver as roman number to the argument, aStream.
     The naive argument controls if the conversion is
     correct (i.e. subtracting prefix notation for 4,9,40,90, etc.),
     or naive (i.e. print 4 as IIII and 9 as VIIII); also called simple.
     The naive version is often used for page numbers in documents."

    |restValue spec|

    restValue := self.
    restValue > 0 ifFalse:[self error:'negative roman'].

    naive ifTrue:[
        spec := #(
                " value string repeat "
                   1000 'M'    true
                    500 'D'    false
                    100 'C'    true
                     50 'L'    false
                     10 'X'    true
                      5 'V'    false
                      1 'I'    true
                 ).
    ] ifFalse:[
        spec := #(
                " value string repeat "
                   1000 'M'    true
                    900 'CM'   false
                    500 'D'    false
                    400 'CD'   false
                    100 'C'    true
                     90 'XC'   false
                     50 'L'    false
                     40 'XL'   false
                     10 'X'    true
                      9 'IX'   false
                      5 'V'    false
                      4 'IV'   false
                      1 'I'    true
                 ).
    ].

    spec
        inGroupsOf:3
        do:[:rValue :rString :repeatFlag |

            [
                (restValue >= rValue) ifTrue:[
                    aStream nextPutAll:rString.
                    restValue := restValue - rValue.
                ].
            ] doWhile:[ repeatFlag and:[ restValue >= rValue] ].
        ].
