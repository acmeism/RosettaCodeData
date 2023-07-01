#(
    (54  546  548  60)
    (1  34  3  98  9  76  45  4)
) do:[:ints |
    (ints copy sort:[:a :b | e'{a}{b}' > e'{b}{a}'])
        do:[:eachNr | eachNr printOn:Stdout].
    Stdout cr.
]
