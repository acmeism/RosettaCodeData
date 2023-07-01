divisors :=
    [:nr |
        |divs|

        divs := Set with:1.
        "no need to check even factors; we are only looking for odd nrs"
        3 to:(nr integerSqrt) by:2 do:[:d | nr % d = 0 ifTrue:[divs add:d; add:(nr / d)]].
        divs.
    ].

isAbundant := [:nr | (divisors value:nr) sum > nr].

"from set of abdundant numbers >= minNr, print nMinPrint-th to nMaxPrint-th"
printNAbundant :=
    [:minNr :nMinPrint :nMaxPrint |
        |count divs|

        count := 0.
        minNr to:Infinity positive doWithExit:[:nr :exit |
            (nr odd and:[isAbundant value:nr]) ifTrue:[
                count := count + 1.
                count >= nMinPrint ifTrue:[
                    divs := divisors value:nr.
                    Transcript
                        show:nr; show:' -> '; show:divs asArray sorted;
                        show:' sum = '; showCR:divs sum.
                ].
                count >= nMaxPrint ifTrue: exit
            ]
        ]
    ].

Transcript showCR:'first 25 odd abundant numbers:'.
"from set of abdundant numbers >= 3, print 1st to 25th"
printNAbundant value:3 value:1 value:25.

Transcript cr; showCR:'first odd abundant number above 1000000000:'.
"from set of abdundant numbers >= 1000000000, print 1st to 1st"
printNAbundant value:1000000000 value:1 value:1.

Transcript cr; showCR:'first odd abundant number above 1000000000000:'.
"from set of abdundant numbers >= 1000000000, print 1st to 1st"
printNAbundant value:1000000000000 value:1 value:1.

Transcript cr; showCR:'the 1000th odd abundant number is:'.
"from set of abdundant numbers>= 3, print 1000th to 1000th"
printNAbundant value:3 value:1000 value:1000.
