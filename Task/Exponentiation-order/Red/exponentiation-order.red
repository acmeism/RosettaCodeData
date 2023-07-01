Red["Exponentiation order"]

exprs: [
    [5 ** 3 ** 2]
    [(5 ** 3) ** 2]
    [5 ** (3 ** 2)]
    [power power 5 3 2]   ;-- functions too
    [power 5 power 3 2]
]

foreach expr exprs [
    print [mold/only expr "=" do expr]
    if find expr '** [
        print [mold/only expr "=" math expr "using math"]
    ]
]
