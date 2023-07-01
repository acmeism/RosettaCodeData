#(
    (54  546  548  60)
    (1  34  3  98  9  76  45  4)
) do:[:ints |
    (ints copy sortByApplying:[:i | i log10 fractionPart]) reverseDo:#print.
    Stdout cr.
]
