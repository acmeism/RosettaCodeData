((main
    { (('foo'   12)
       ('bar'   33)
       ('baz'   42))
    mkhash !

    entsha
    dup
    {1 ith nl <<} each

    "-----\n" <<

    {2 ith %d nl <<} each})

(mkhash
    { <- newha ->
    { <- dup ->
        dup 1 ith
        <- 0 ith ->
        inskha }
    each }))
