| potentialPrimes limit |
limit := 100.
potentialPrimes := Array new: limit.
potentialPrimes atAllPut: true.
2 to: limit sqrt do: [:testNumber |
    (potentialPrimes at: testNumber) ifTrue: [
        (testNumber * 2) to: limit by: testNumber do: [:nonPrime |
            potentialPrimes at: nonPrime put: false
        ]
    ]
].
2 to: limit do: [:testNumber |
    (potentialPrimes at: testNumber) ifTrue: [
        Transcript show: testNumber asString; cr
    ]
]
