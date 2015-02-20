((main {
    { iter
        1 take bons 1 take
        dup cp
        {*} cp
        3 take
        append }
    10 times
    collect !
    {eval %d nl <<} each }))
