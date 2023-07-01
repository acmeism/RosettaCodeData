methods := #(= ~= > >= < <= sameAs: ).
#(
    ('YUP' 'YUP')
    ('YUP' 'yup')
) pairsDo:[:s1 :s2 |
    methods do:[:m |
        '%-20s\t%s\n' printf:
            {
                ('(%S %s %S)' printf:{s1 . m . s2}) .
                (s1 perform:m with:s2)
            } on:Stdout
    ].
    Stdout cr
]
