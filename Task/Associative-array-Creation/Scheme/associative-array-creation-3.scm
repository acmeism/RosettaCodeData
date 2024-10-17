#!r6rs

(import (rnrs base)
        (rnrs hashtables (6)))

(define my-hash (make-hashtable equal-hash equal?))
(hashtable-set! my-hash 'a 'b)
(hashtable-set! my-hash 1 'hello)
(hashtable-set! my-hash "c" '(a b c))
