(define-syntax-rule (string-copy s) (string-append s)) ;; copy = append nothing
    → #syntax:string-copy
(define s "abc")
(define t (string-copy s))
    t → "abc"
(eq? s t) → #t ;; same reference, same object
