: (setq A '((a . b) (c d e) f g . e))
-> ((a . b) (c d e) f g . e)

: (setq B (deepCopy A))
-> ((a . b) (c d e) f g . e)

: A
-> ((a . b) (c d e) f g . e)

: B
-> ((a . b) (c d e) f g . e)

: (= A B)
-> T              # A and its copy B are structure-equal
: (== A B)
-> NIL            # but they are not identical (pointer-equal)

: (cadr A)
-> (c d e)

: (cadr B)
-> (c d e)

: (== (cadr A) (cadr B))
-> NIL            # The same holds for sub-structures
