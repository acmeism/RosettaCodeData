define : levenshtein s t
    define cache : make-hash-table
    let loop
        : s : string->list s
          sl : string-length s
          t : string->list t
          tl : string-length t
        define cached : hash-ref cache : cons sl tl
        cond
          (zero? sl) tl
          (zero? tl) sl
          cached cached
          else
            hash-set! cache : cons sl tl
              let : : d : if (char=? (car s) (car t)) 0 1
                min : + 1 : loop (cdr s) (1- sl) t tl
                      + 1 : loop s sl (cdr t) (1- tl)
                      + d : loop (cdr s) (1- sl) (cdr t) (1- tl)
levenshtein "kitten" "sitting"
