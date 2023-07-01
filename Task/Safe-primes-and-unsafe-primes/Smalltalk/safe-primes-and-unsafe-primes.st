[
    | isSafePrime printFirstNElements |

    isSafePrime := [:p | ((p-1)//2) isPrime].
    printFirstNElements :=
        [:coll :n |
            (coll to:n)
                do:[:p | Transcript show:p]
                separatedBy:[Transcript space]
        ].
    (Iterator on:[:b | Integer primesUpTo:10000000 do:b])
        partition:isSafePrime
        into:[:savePrimes :unsavePrimes |
            |nSaveBelow1M nSaveBelow10M nUnsaveBelow1M nUnsaveBelow10M|

            nSaveBelow1M := savePrimes count:[:p | p < 1000000].
            nSaveBelow10M := savePrimes size.

            nUnsaveBelow1M := unsavePrimes count:[:p | p < 1000000].
            nUnsaveBelow10M := unsavePrimes size.

            Transcript showCR: 'first 35 safe primes:'.
            printFirstNElements value:savePrimes value:35.
            Transcript cr.

            Transcript show: 'safe primes below 1,000,000: '.
            Transcript showCR:nSaveBelow1M printStringWithThousandsSeparator.

            Transcript show: 'safe primes below 10,000,000: '.
            Transcript showCR:nSaveBelow10M printStringWithThousandsSeparator.

            Transcript showCR: 'first 40 unsafe primes:'.
            printFirstNElements value:unsavePrimes value:40.
            Transcript cr.

            Transcript show: 'unsafe primes below 1,000,000: '.
            Transcript showCR:nUnsaveBelow1M printStringWithThousandsSeparator.

            Transcript show: 'unsafe primes below 10,000,000: '.
            Transcript showCR:nUnsaveBelow10M printStringWithThousandsSeparator.
        ]
 ] benchmark:'runtime: safe primes'
