x := #( 1 2 3 1e11 ).
y := x collect:#sqrt.
xprecision := 3.
yprecision := 5.

'sqrt.dat' asFilename writingFileDo:[:fileStream |
    x with:y do:[:xI :yI |
        '%.*g\t%.*g\n' printf:{ xprecision . xI . yprecision . yI } on:fileStream
    ]
]
