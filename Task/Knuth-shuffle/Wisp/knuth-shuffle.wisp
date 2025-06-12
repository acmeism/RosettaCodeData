import : only (srfi :27 random-bits) random-integer
         srfi :64 tests

define : vector-shuffle! vec
    . "Shuffle the vector VEC with Knuth shuffle"
    define len : vector-length vec
    define : swap! i j
        define tmp : vector-ref vec i
        vector-set! vec i : vector-ref vec j
        vector-set! vec j tmp
    cond
      : <= len 1
        . vec
      else
        for-each : λ (i) : swap! i : random-integer i
          reverse : cdr : iota len
        . vec

define : list-shuffle the-list
    . "Shuffle a list in O(N) with Knuth shuffle using an intermediate vector."
    vector->list : vector-shuffle! : list->vector the-list

;; deterministic tests
test-begin "knuth-shuffle"
test-equal '() : list-shuffle '()
test-equal '(1) : list-shuffle '(1)
test-end
;; sample run
display : list-shuffle '(1 2 3 4)
newline
