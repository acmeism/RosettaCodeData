((main
    { (1 1 2 3 5 8 13 21)
    {double !} each
    collect !
    {%d ' ' . <<} each})

(double { 2 * })

(collect { -1 take }))
