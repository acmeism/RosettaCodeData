((main
    { (1 1 2 3 5 8 13 21) dup
    {double !} each
    {%d ' ' . <<} each})

(double { dup 2 * set }))
