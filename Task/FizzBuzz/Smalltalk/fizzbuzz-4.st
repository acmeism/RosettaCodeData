0 to: 100 do: [ :i |
    (i \\ 3 = 0 and: [ i \\ 5 = 0 ])
        ifTrue: [ Transcript show: 'FizzBuzz'; cr. ]
        ifFalse: [
            (i \\ 3 = 0)
                ifTrue: [ Transcript show: 'Fizz'; cr. ].
            (i \\ 5 = 0)
                ifTrue: [ Transcript show: 'Buzz'; cr. ].
            ((i \\ 3 ~= 0) and: [ i \\ 5 ~= 0 ])
                ifTrue: [ Transcript show: i printString; cr. ].
        ].
].
