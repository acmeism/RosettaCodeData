Integer extend [
    fizzbuzz [
        | fb |
        fb := '%<Fizz|>1%<Buzz|>2' % {
            self \\ 3 == 0.  self \\ 5 == 0 }.
        ^fb isEmpty ifTrue: [ self ] ifFalse: [ fb ]
    ]
]
1 to: 100 do: [ :i | i fizzbuzz displayNl ]
