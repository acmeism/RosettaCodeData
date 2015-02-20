((main { (5 9) foo ! })

(foo {
    ({cand} {cor} {cnor} {cxor} {cxnor} {cushl} {cushr} {cashr} {curol} {curor})
    { <- dup give ->
        eval
        %x nl <<}
    each
    give zap
    cnot %x nl <<}))
