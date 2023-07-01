#(
    (54  546  548  60)
    (1  34  3  98  9  76  45  4)
) do:[:ints |
    |resultString|

    "sort ints by padded strings (sort a copy - literals are immudatble),
     then collect their strings, then concatenate"
    resultString :=
        ((ints copy sort:[:a :b |
                |pad|
                pad := (a integerLog10) max:(b integerLog10).
                (a printString paddedTo:pad with:$0) > (b printString paddedTo:pad with:$0)])
            collect:#printString) asStringWith:''.
    Stdout printCR: resultString.
].
