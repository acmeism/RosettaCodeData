; Convert an integer into a list of its digits.

(define integer->list
  (lambda (integer)
    (let loop ((list '()) (int integer))
      (if (< int 10)
        (cons int list)
        (loop (cons (remainder int 10) list) (quotient int 10))))))

; Return the sum of the digits of an integer.

(define integer-sum-digits
  (lambda (integer)
    (fold-left + 0 (integer->list integer))))

; Compute the digital root (additive) and additive persistence of an integer.
; Return as a cons of (adr . ap).

(define adr-ap
  (lambda (integer)
    (let loop ((int integer) (cnt 0))
      (if (< int 10)
        (cons int cnt)
        (loop (integer-sum-digits int) (1+ cnt))))))

; Emit a table of integer, digital root (additive), and additive persistence
; for the example integers given.

(printf "~13@a ~6@a ~6@a~%" "Integer" "Root" "Pers.")
(let rowloop ((intlist '(627615 39390 588225 393900588225 0 1 68010887038)))
  (when (pair? intlist)
    (let* ((int (car intlist))
           (aa (adr-ap int)))
      (printf "~13@a ~6@a ~6@a~%" int (car aa) (cdr aa))
      (rowloop (cdr intlist)))))
