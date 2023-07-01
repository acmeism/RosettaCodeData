(context 'PGR)                              ;; Switch to context (say namespace) PGR
(define (is-pangram? str)
    (setf chars (explode (upper-case str))) ;; Uppercase + convert string into a list of chars
    (setf is-pangram-status true)           ;; Default return value of function
    (for (c (char "A") (char "Z") 1 (nil? is-pangram-status)) ;; For loop with break condition
        (if (not (find (char c) chars))     ;; If char not found in list, "is-pangram-status" becomes "nil"
            (setf is-pangram-status nil)
        )
    )
    is-pangram-status                       ;; Return current value of symbol "is-pangram-status"
)
(context 'MAIN)                             ;; Back to MAIN context

;; - - - - - - - - - -

(println (PGR:is-pangram? "abcdefghijklmnopqrstuvwxyz"))  ;; Print true
(println (PGR:is-pangram? "abcdef"))  ;; Print nil
(exit)
