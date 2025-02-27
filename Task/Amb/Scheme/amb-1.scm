(define fail
  (lambda ()
    (error "Amb tree exhausted")))

(define-syntax amb
  (syntax-rules ()
    ((AMB) (FAIL))                      ; Two shortcuts.
    ((AMB expression) expression)

    ((AMB expression ...)
     (LET ((FAIL-SAVE FAIL))
       ((CALL-WITH-CURRENT-CONTINUATION ; Capture a continuation to
          (LAMBDA (K-SUCCESS)           ;   which we return possibles.
            (CALL-WITH-CURRENT-CONTINUATION
              (LAMBDA (K-FAILURE)       ; K-FAILURE will try the next
                (SET! FAIL (LAMBDA () (K-FAILURE 'anything-is-fine-here)))   ;   possible expression.
                (K-SUCCESS              ; Note that the expression is
                 (LAMBDA ()             ;   evaluated in tail position
                   expression))))       ;   with respect to AMB.
            ...
            (SET! FAIL FAIL-SAVE)      ; Finally, if this is reached,
            FAIL-SAVE)))))))            ;   we restore the saved FAIL.


(let ((w-1 (amb "the" "that" "a"))
      (w-2 (amb "frog" "elephant" "thing"))
      (w-3 (amb "walked" "treaded" "grows"))
      (w-4 (amb "slowly" "quickly")))
  (define (joins? left right)
    (equal? (string-ref left (- (string-length left) 1)) (string-ref right 0)))
  (if (joins? w-1 w-2) '() (amb))
  (if (joins? w-2 w-3) '() (amb))
  (if (joins? w-3 w-4) '() (amb))
  (list w-1 w-2 w-3 w-4))
