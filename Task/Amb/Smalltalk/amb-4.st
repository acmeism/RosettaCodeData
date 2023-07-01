!Amb class methods!

until:questionBlock in:aBlock
    "compute solutions, asking if more solutions are to be searched
     via questionBlock (gets the found solution as arg)"

    |allResults|

    allResults := OrderedCollection new.

    aBlock on:FoundSolution do:[:ex |
        allResults add:ex parameter.
        (questionBlock value:ex parameter) ifTrue:[^ allResults].
        ex proceedWith:nil.
    ].
    ^ allResults
!

allSolutions:aBlock
    ^ self until:[:solution | false] in:aBlock
!
