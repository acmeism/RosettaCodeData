; sample function
(define (function) (display "+"))

; simple case for 80 times
(for-each (lambda (unused) (function)) (iota 80))
(print) ; print newline
; ==> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; detailed case for 80 times
(let loop ((fnc function) (n 80))
   (unless (zero? n)
      (begin
         (fnc)
         (loop fnc (- n 1)))))
(print) ; print newline
; ==> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
