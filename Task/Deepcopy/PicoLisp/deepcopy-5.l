: (setq A '(a b .)  B (deepCopy A))
-> (a b .)
: A
-> (a b .)
: B
-> (a b .)

: (= A B)
-> T              # A and its copy B are structure-equal

: (== A B)
-> NIL            # but they are not identical (pointer-equal)
